import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:provider/provider.dart';
import 'package:winterhack_2021/data/shared_storage.dart';
import 'package:winterhack_2021/widgets/selector_card.dart';

class AddedLocations extends StatefulWidget {
  const AddedLocations({Key? key}) : super(key: key);

  @override
  _AddedLocationsState createState() => _AddedLocationsState();
}

class _AddedLocationsState extends State<AddedLocations> {
  var currentgeofences;

  void getGeofences() async {
    currentgeofences = await bg.BackgroundGeolocation.geofences;
    setState(() {});
  }

  void removeGeofence(String locationName, GlobalModel model) async {
    await bg.BackgroundGeolocation.removeGeofence(locationName);
    var existing = model.savedLocations.getValue(locationName);
    if (existing != null) {
      existing.isEnabled = false;
      model.savedLocations.upsert(existing);
    }
  }
  void addGeofence(String locationName, GlobalModel model) async {
    await bg.BackgroundGeolocation.removeGeofence(locationName);
    var existing = model.savedLocations.getValue(locationName);
    if (existing != null) {
      existing.isEnabled = false;
      model.savedLocations.upsert(existing);
    }
  }

  void addGeofence(String geofencename, double long, double lat, double radius,
      GlobalModel model) {
    bg.BackgroundGeolocation.addGeofence(bg.Geofence(
        notifyOnExit: true,
        notifyOnEntry: true,
        radius: radius,
        identifier: '$geofencename',
        latitude: lat,
        longitude: long));
    model.savedLocations
        .upsert(SavedLocation(lat, long, radius, geofencename, true));
  }

  @override
  void initState() {
    getGeofences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Saved Locations'),
        ),
        body: Consumer<GlobalModel>(
          builder: (context, value, child) {
            return ListView(children: [
              ...value.savedLocations.items.map((e) {
                return SelectorCardWidget(
                    name: e.locationName,
                    isActive: e.isEnabled,
                    onChanged: (selected) {
                      if (!selected) removeGeofence(e.locationName, value);
                    });
              })
            ]);
          },
        ));
  }
}
