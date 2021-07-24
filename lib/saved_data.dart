import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String SAVED_LOCATION_KEY = "savedLocations";
const String DISABLED_APPS_KEY = "disabledApps";
const String TOTAL_TIME = "totalTime";

class GlobalModel extends ChangeNotifier {
  static GlobalModel _singleton = GlobalModel._();
  StorageStringList? _savedLocations;
  StorageStringList? _disabledApps;
  int _totalTime = -1;

  static Widget asWidget(Widget child) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => _singleton, child: child);
  }

  GlobalModel._() {
    _init().then((_) {
      _savedLocations!.addListener(() => notifyListeners());
      _disabledApps!.addListener(() => notifyListeners());
    });
  }

  Future<void> _init() async {
    _savedLocations = await _getStringList(SAVED_LOCATION_KEY);
    _disabledApps = await _getStringList(DISABLED_APPS_KEY);
    _totalTime = await _getTotalTime();
    notifyListeners();
  }

  int get totalTime => _totalTime;

  StorageStringList get savedLocations => _savedLocations == null
      ? StorageStringList([], SAVED_LOCATION_KEY)
      : _savedLocations!;

  StorageStringList get disabledApps => _disabledApps == null
      ? StorageStringList([], DISABLED_APPS_KEY)
      : _disabledApps!;

  setTotalTime(int time) async {
    _totalTime = time;
    (await SharedPreferences.getInstance()).setInt(TOTAL_TIME, _totalTime);
    notifyListeners();
  }
}

Future<int> _getTotalTime() async {
  final result = (await SharedPreferences.getInstance()).getInt(TOTAL_TIME);
  return result ?? 0;
}

class StorageStringList extends ChangeNotifier {
  late Map<String, bool> _backingMap;
  String key;

  StorageStringList(List<String> backingList, this.key) {
    _backingMap = Map();
    for (var x in backingList) {
      List<String> split = x.split(":");
      _backingMap.putIfAbsent(
          split[0],
          // Try set boolean if it exists.
          () => split.length > 1 ? split[1].toLowerCase() == 'true' : false);
    }
  }

  _saveList() async => (await SharedPreferences.getInstance()).setStringList(
      key,
      List.of(
          _backingMap.entries.map((e) => "${e.key}:${e.value.toString()}")));

  Future<bool> upsert(String key, bool val) async {
    final didUpdate =
        _backingMap.update(key, (value) => val, ifAbsent: () => val) == val;
    // if changed
    if (didUpdate) await _saveList();
    notifyListeners();
    return didUpdate;
  }

  Future<bool> remove(String val) async {
    final didRemove = _backingMap.remove(val) != null;
    // if something was removed
    if (didRemove) {
      await _saveList();
    }
    notifyListeners();
    return didRemove;
  }

  bool? get(String val) {
    return _backingMap[val];
  }

  bool contains(String? val) => _backingMap.containsKey(val);

  clear() {
    _backingMap.clear();
    notifyListeners();
  }

  UnmodifiableMapView<String, bool> get items =>
      UnmodifiableMapView(_backingMap);
}

Future<StorageStringList> _getStringList(String key) async {
  final result = (await SharedPreferences.getInstance()).getStringList(key);
  if (result == null) {
    return StorageStringList([], key);
  }
  print("Loaded List from Storage " + result.toString());
  return StorageStringList(result, key);
}
