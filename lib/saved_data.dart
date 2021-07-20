import 'package:shared_preferences/shared_preferences.dart';

const String SAVED_LOCATION_KEY = "savedLocations";
const String DISABLED_APPS_KEY = "disabledApps";
const String TOTAL_TIME = "totalTime";
// TODO make these providers so they update widgets on state change
StorageStringList? _savedLocations;
StorageStringList? _disabledApps;

Future<StorageStringList> getSavedLocations() async {
  if (_savedLocations == null) {
    _savedLocations = await _getStringList(SAVED_LOCATION_KEY);
  }
  return _savedLocations!;
}

Future<StorageStringList> getDisabledApps() async {
  if (_disabledApps == null) {
    _disabledApps = await _getStringList(DISABLED_APPS_KEY);
  }
  return _disabledApps!;
}

Future<int> getTotalTime() async {
  final result = (await SharedPreferences.getInstance()).getInt(TOTAL_TIME);
  return result ?? 0;
}

setTotalTime(int time) async =>
    (await SharedPreferences.getInstance()).setInt(TOTAL_TIME, time);

class StorageStringList {
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
    return result;
  }

  Future<bool> remove(String val) async {
    final result = _backingSet.remove(val);
    if (result) {
      await _saveList();
    }
    return result;
  }

  bool contains(String val) {
    return _backingSet.contains(val);
  }

  Set<String> iter() {
    return Set.unmodifiable(_backingSet);
  }
}

Future<StorageStringList> _getStringList(String key) async {
  final result = (await SharedPreferences.getInstance()).getStringList(key);
  if (result == null) {
    return StorageStringList([], key);
  }
  print("SET " + result.toString());
  return StorageStringList(result, key);
}
