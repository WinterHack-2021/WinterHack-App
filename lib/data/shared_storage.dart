import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'schema.dart';

const String SAVED_LOCATION_KEY = "savedLocations";
const String DISABLED_APPS_KEY = "disabledApps";
const String TOTAL_TIME = "totalTime";
const String ON_TRACK = "onTrack";

const platform = const MethodChannel('winterhack-channel');

class GlobalModel extends ChangeNotifier {
  static GlobalModel _singleton = GlobalModel._();
  StorageMap<SavedLocation>? _savedLocations;
  StorageMap<App>? _disabledApps;
  int _totalTime = -1;
  bool _isOnTrack = false;
  bool _loading = true;

  // This value should only be above 0 if isOnTrack is currently true
  // The idea is that when isOnTrack is turned false, the duration this var stores
  // is transferred to totalTime and this lastofftime is reset to -1
  int _lastOffTime = -1;

  static Widget asWidget(Widget child) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => _singleton, child: child);
  }

  _refreshGeofences() async {
    await bg.BackgroundGeolocation.removeGeofences();
    var validGeofences = List.of(savedLocations.items
        .where((element) => element.isEnabled)
        .map((e) => bg.Geofence(
            notifyOnExit: true,
            notifyOnEntry: true,
            radius: e.radius,
            identifier: '${e.locationName}',
            latitude: e.lat,
            longitude: e.long)));
    if (validGeofences.isNotEmpty)
      await bg.BackgroundGeolocation.addGeofences(validGeofences);
  }

  GlobalModel._() {
    _init().then((_) {
      _savedLocations!.addListener(() {
        _refreshGeofences();
        notifyListeners();
      });
      _disabledApps!.addListener(() {
        _updateNativeService();
        notifyListeners();
      });
      _updateNativeService();
      _refreshGeofences();
      notifyListeners();
      _loading = false;
    });
    // Let service know of init values
  }

  _updateNativeService() async {
    await platform.invokeMethod("setEnabled", _isOnTrack);
    await platform.invokeMethod(
        "setDisabledApps",
        _disabledApps!.items
            .where((e) => e.isEnabled)
            .map((e) => e.packageName)
            .toList(growable: false));
  }

  Future<void> _init() async {
    _savedLocations = (await _getStringList<SavedLocation>(
            SAVED_LOCATION_KEY, (val) => SavedLocation.fromJsonMap(val)))
        as StorageMap<SavedLocation>?;
    _disabledApps = (await _getStringList<App>(
        DISABLED_APPS_KEY, (val) => App.fromJsonMap(val))) as StorageMap<App>?;
    _totalTime = await _getTotalTime();
    _isOnTrack = await _getIsOnTrack();
    notifyListeners();
  }

  int get totalTime {
    if (_lastOffTime <= 0) return _totalTime;
    final timeSinceOff = DateTime.now().millisecondsSinceEpoch - _lastOffTime;
    return _totalTime + timeSinceOff;
  }

  bool get isOnTrack => _isOnTrack;

  bool get loading => _loading;

  set isOnTrack(bool newIsOnTrack) {
    _isOnTrack = newIsOnTrack;
    SharedPreferences.getInstance().then((value) =>
        value.setBool(ON_TRACK, _isOnTrack).then((value) => notifyListeners()));
    // if recently turned off
    if (!newIsOnTrack) {
      if (_lastOffTime > 0) {
        print(
            "adding time ${DateTime.now().millisecondsSinceEpoch - _lastOffTime}");
        _addTotalTime(DateTime.now().millisecondsSinceEpoch - _lastOffTime);
        _lastOffTime = -1;
      }
    } else
      _lastOffTime = DateTime.now().millisecondsSinceEpoch;

    _updateNativeService();
    notifyListeners();
  }

  StorageMap<SavedLocation> get savedLocations => _savedLocations == null
      ? StorageMap.immutableEmpty(SAVED_LOCATION_KEY)
      : _savedLocations!;

  StorageMap<App> get disabledApps => _disabledApps == null
      ? StorageMap.immutableEmpty(DISABLED_APPS_KEY)
      : _disabledApps!;

  _addTotalTime(int newTime) async {
    _totalTime += newTime;
    await (await SharedPreferences.getInstance())
        .setInt(TOTAL_TIME, _totalTime);
    notifyListeners();
  }
}

Future<int> _getTotalTime() async {
  final result = (await SharedPreferences.getInstance()).getInt(TOTAL_TIME);
  return result ?? 0;
}

Future<bool> _getIsOnTrack() async {
  final result = (await SharedPreferences.getInstance()).getBool(ON_TRACK);
  return result ?? false;
}

Future<StorageMap> _getStringList<T extends WithBool>(
    String key, T Function(Map<String, dynamic> json) make) async {
  final result = (await SharedPreferences.getInstance()).getStringList(key);
  if (result == null) {
    return StorageMap<T>([], key, make);
  }
  print("Loaded List from Storage " + result.toString());
  return StorageMap<T>(result, key, make);
}
