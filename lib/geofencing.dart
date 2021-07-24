import 'dart:async';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'googlemaps.dart';
import 'clickable_container.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
          child: ListView(
            children: [
              TextButton(
                  onPressed: () {
                    addGeofence(geofencename, long, lat, radius);
                  },
                  child: Text('Add Location')),
              Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: 'Location'),
                  )),
              Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: 'Radius'),
                  )),
              GoogleMaps(),
              //ClickableLocationContainer(),
            ],
          ),
        ));
  }
}

void headlessTask(bg.HeadlessEvent headlessEvent) async {
  print('Started HeadlessTask: $headlessEvent');
  bg.GeofenceEvent geofenceEvent = headlessEvent.event;
  print('${geofenceEvent.action}');
  print('${geofenceEvent.identifier}');
}

void _getUserPosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  Position userLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}
