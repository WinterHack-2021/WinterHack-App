import 'dart:collection';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Serializable {
  String getKey();

  Map<String, dynamic> toJsonMap();

  String toJson() {
    return json.encode(toJsonMap());
  }

  // Support for sets and uniqueness
  @override
  bool operator ==(Object other) {
    if (!(other is Serializable)) return false;
    return other.getKey() == getKey();
  }

  @override
  int get hashCode => getKey().hashCode;
}

abstract class WithBool extends Serializable {
  bool isEnabled = false;

  WithBool(this.isEnabled);

  WithBool.fromJsonMap(Map<String, dynamic> json)
      : isEnabled = json['isEnabled'];

  @override
  setFromJsonMap(Map<String, dynamic> json) {
    isEnabled = json['isEnabled'];
  }

  @override
  Map<String, dynamic> toJsonMap() => {'isEnabled': isEnabled};
}

class App extends WithBool {
  String appName;
  String packageName;

  App(this.appName, this.packageName, bool isEnabled) : super(isEnabled);

  App.fromJsonMap(Map<String, dynamic> json)
      : appName = json['appName'],
        packageName = json['packageName'],
        super.fromJsonMap(json);

  @override
  Map<String, dynamic> toJsonMap() {
    final map = super.toJsonMap();
    map['appName'] = appName;
    map['packageName'] = packageName;

    return map;
  }

  @override
  String getKey() {
    return packageName;
  }
}

class SavedLocation extends WithBool {
  double lat, long, radius;
  String locationName;

  SavedLocation(
      this.lat, this.long, this.radius, this.locationName, bool isEnabled)
      : super(isEnabled);

  SavedLocation.fromJsonMap(Map<String, dynamic> json)
      : lat = json['lat'],
        long = json['long'],
        radius = json['radius'],
        locationName = json['locationName'],
        super.fromJsonMap(json);

  @override
  Map<String, dynamic> toJsonMap() {
    final map = super.toJsonMap();
    map['lat'] = lat;
    map['long'] = long;
    map['radius'] = radius;
    map['locationName'] = locationName;

    return map;
  }

  @override
  String getKey() {
    return locationName;
  }
}

class StorageMap<T extends WithBool> extends ChangeNotifier {
  late Set<T> _backingMap;
  String key;

  StorageMap(List<String> backingList, this.key,
      T Function(Map<String, dynamic> json) make) {
    _backingMap = Set();
    for (var x in backingList) {
      try {
        Map<String, dynamic> jsonMap = json.decode(x);
        _backingMap.add(make(jsonMap));
      } catch (e) {
        print("Failed to parse: $x, error: $e");
      }
    }
  }

  StorageMap.immutableEmpty(this.key) {
    _backingMap = Set.unmodifiable([]);
  }

  _saveList() async => (await SharedPreferences.getInstance())
      .setStringList(key, List.of(_backingMap.map((e) => e.toJson())));

  Future<bool> upsert(T val) async {
    final didUpdate = _backingMap.add(val);
    // if didn't change, likely boolean change
    if (!didUpdate) {
      _backingMap
          .firstWhere((element) => element.getKey() == val.getKey())
          .isEnabled = val.isEnabled;
    }

    await _saveList();
    notifyListeners();
    return didUpdate;
  }

  void remove(String key) async {
    _backingMap.removeWhere((element) => element.getKey() == key);
    await _saveList();
    notifyListeners();
  }

  bool? get(String key) {
    return getValue(key)?.isEnabled;
  }

  T? getValue(String key) {
    try {
      return _backingMap.firstWhere((element) => element.getKey() == key);
    } catch (e) {
      return null;
    }
  }

  bool contains(String? key) => get(key ?? "") != null;

  clear() {
    _backingMap.clear();
    notifyListeners();
  }

  UnmodifiableSetView<T> get items => UnmodifiableSetView(_backingMap);
}
