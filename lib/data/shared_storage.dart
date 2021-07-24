import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'schema.dart';

const String SAVED_LOCATION_KEY = "savedLocations";
const String DISABLED_APPS_KEY = "disabledApps";
const String TOTAL_TIME = "totalTime";
const String ON_TRACK = "onTrack";

const platform = const MethodChannel('winterhack-channel');

class GlobalModel extends ChangeNotifier {
  static GlobalModel _singleton = GlobalModel._();
  StorageMap<Location>? _savedLocations;
  StorageMap<App>? _disabledApps;
  int _totalTime = -1;
  bool _isOnTrack = false;

  // This value should only be above 0 if isOnTrack is currently true
  // The idea is that when isOnTrack is turned false, the duration this var stores
  // is transferred to totalTime and this lastofftime is reset to -1
  int _lastOffTime = -1;

  static Widget asWidget(Widget child) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => _singleton, child: child);
  }

  GlobalModel._() {
    _init().then((_) {
      _savedLocations!.addListener(() => notifyListeners());
      _disabledApps!.addListener(() {

        platform.invokeMethod(
            "setDisabledApps", _disabledApps!.items.where((e)=>e.isEnabled).map((e) => e.packageName).toList(growable: false));
        notifyListeners();
      });
    });
  }

  Future<void> _init() async {
    _savedLocations = (await _getStringList(
            SAVED_LOCATION_KEY, (val) => Location.fromJsonMap(val)))
        as StorageMap<Location>?;
    _disabledApps =
        (await _getStringList(DISABLED_APPS_KEY, (val) => App.fromJsonMap(val)))
            as StorageMap<App>?;
    _totalTime = await _getTotalTime();
    _isOnTrack = await _getIsOnTrack();
    notifyListeners();
  }

  int get totalTime {
    if (_lastOffTime <= 0) return _totalTime;
    final timeSinceOff = DateTime.now().millisecondsSinceEpoch - _lastOffTime;
    return _totalTime + timeSinceOff;
  }

  _addTotalTime(int newTime) async {
    _totalTime += newTime;
    await (await SharedPreferences.getInstance())
        .setInt(TOTAL_TIME, _totalTime);
    notifyListeners();
  }

  bool get isOnTrack => _isOnTrack;

  set isOnTrack(bool newIsOnTrack) {
    _isOnTrack = newIsOnTrack;
    SharedPreferences.getInstance().then((value) =>
        value.setBool(ON_TRACK, _isOnTrack).then((value) => notifyListeners()));
    // if recently turned off
    if (!newIsOnTrack) {
      print(
          "adding time ${DateTime.now().millisecondsSinceEpoch - _lastOffTime}");
      _addTotalTime(DateTime.now().millisecondsSinceEpoch - _lastOffTime);
      _lastOffTime = -1;
    } else
      _lastOffTime = DateTime.now().millisecondsSinceEpoch;
  }

  StorageMap<Location> get savedLocations => _savedLocations == null
      ? StorageMap.immutableEmpty(SAVED_LOCATION_KEY)
      : _savedLocations!;

  StorageMap<App> get disabledApps => _disabledApps == null
      ? StorageMap.immutableEmpty(DISABLED_APPS_KEY)
      : _disabledApps!;
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
    return StorageMap([], key, make);
  }
  print("Loaded List from Storage " + result.toString());
  return StorageMap<T>(result, key, make);
}
