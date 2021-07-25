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

  void toggleGeofence(
      String locationName, GlobalModel model, bool isSelected) async {
    var existing = model.savedLocations.getValue(locationName);
    if (existing != null) {
      existing.isEnabled = isSelected;
      model.savedLocations.upsert(existing);
    }
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
                      toggleGeofence(e.locationName, value, selected);
                    });
              })
            ]);
          },
        ));
  }
}
