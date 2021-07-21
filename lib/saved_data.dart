import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String SAVED_LOCATION_KEY = "savedLocations";
const String DISABLED_APPS_KEY = "disabledApps";
const String TOTAL_TIME = "totalTime";
// TODO make these providers so they update widgets on state change

class GlobalModel extends ChangeNotifier {
  StorageStringList? _savedLocations;
  StorageStringList? _disabledApps;
  int _totalTime = -1;

  GlobalModel() {
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
  late Set<String> _backingSet;
  String key;

  StorageStringList(List<String> backingList, this.key) {
    _backingSet = Set.of(backingList);
  }

  _saveList() async => (await SharedPreferences.getInstance())
      .setStringList(key, List.of(_backingSet));

  Future<bool> add(String val) async {
    final result = _backingSet.add(val);
    if (result) await _saveList();
    notifyListeners();
    return result;
  }

  Future<bool> remove(String val) async {
    final result = _backingSet.remove(val);
    if (result) {
      await _saveList();
    }
    notifyListeners();
    return result;
  }

  bool contains(String val) {
    return _backingSet.contains(val);
  }

  clear() {
    _backingSet.clear();
    notifyListeners();
  }

  UnmodifiableSetView<String> get items => UnmodifiableSetView(_backingSet);
}

Future<StorageStringList> _getStringList(String key) async {
  final result = (await SharedPreferences.getInstance()).getStringList(key);
  if (result == null) {
    return StorageStringList([], key);
  }
  print("Loaded List from Storage " + result.toString());
  return StorageStringList(result, key);
}
