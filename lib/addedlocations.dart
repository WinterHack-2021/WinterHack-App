import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class AddedLocations extends StatefulWidget {
  const AddedLocations({Key? key}) : super(key: key);

  @override
  _AddedLocationsState createState() => _AddedLocationsState();
}

class _AddedLocationsState extends State<AddedLocations> {
  dynamic currentgeofences;

  void getGeofences() async {
    currentgeofences = await bg.BackgroundGeolocation.geofences;
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
        body: Column(
            children: [Container(child: Text(currentgeofences.toString()))]));
  }
}
