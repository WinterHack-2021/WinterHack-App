import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class GeoFence extends StatefulWidget {
  const GeoFence({Key? key}) : super(key: key);

  @override
  _GeoFenceState createState() => _GeoFenceState();
}

class _GeoFenceState extends State<GeoFence> {
  String geofencename = 'Home';
  double long = 144.685666;
  double lat = -37.842921;
  double radius = 50;

  void addGeofence(geofencename, long, lat, radius) {
    bg.BackgroundGeolocation.addGeofence(bg.Geofence(
        notifyOnExit: true,
        notifyOnEntry: true,
        radius: radius,
        identifier: '$geofencename',
        latitude: lat,
        longitude: long));
    print('addded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Locations'),
        ),
        body: Container(
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    addGeofence(geofencename, long, lat, radius);
                  },
                  child: Text('Add Location')),
              TextButton(
                onPressed: () async {
                  List<bg.Geofence> geofences =
                      await bg.BackgroundGeolocation.geofences;
                  print('[getGeofences: $geofences');
                },
                child: Text('Print Registed Geofences'),
              )
            ],
          ),
        ));
  }
}
