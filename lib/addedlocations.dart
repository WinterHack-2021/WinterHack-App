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
  var currentgeofences;

  void getGeofences() async {
    currentgeofences = await bg.BackgroundGeolocation.geofences;
    setState(() {});
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
        body: Column(children: [
          (currentgeofences == null)
              ? Center(child: CircularProgressIndicator())
              : Container(child: Text(currentgeofences.toString()))
        ]));
  }
}
