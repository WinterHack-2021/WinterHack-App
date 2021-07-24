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

class Location extends WithBool {
  int lat, long, radius;
  String locationName;

  Location.fromJsonMap(Map<String, dynamic> json)
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
  T Function(Map<String, dynamic> json) make;

  StorageMap(List<String> backingList, this.key, this.make) {
    _backingMap = Set();
    for (var x in backingList) {
      Map<String, dynamic> jsonMap = json.decode(x);
      _backingMap.add(make(jsonMap));
    }
  }

  _saveList() async => (await SharedPreferences.getInstance())
      .setStringList(key, List.of(_backingMap.map((e) => e.toJson())));

  Future<bool> upsert(T key) async {
    final didUpdate = _backingMap.add(key);
    // if didn't change, likely boolean change
    if (!didUpdate) {
      _backingMap
          .firstWhere((element) => element.getKey() == key.getKey())
          .isEnabled = key.isEnabled;
    }

    await _saveList();
    notifyListeners();
    return didUpdate;
  }

  void remove(String val) async {
    _backingMap.removeWhere((element) => element.getKey() == val);
    // if something was removed
    await _saveList();
    notifyListeners();
  }

  bool? get(String key) {
    try {
      return _backingMap
          .firstWhere((element) => element.getKey() == key)
          .isEnabled;
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
