import 'dart:async';
import 'main.dart';
import 'package:flutter/material.dart';
import 'googlemaps.dart';
import 'clickable_container.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'placesapi.dart';
import 'package:provider/provider.dart';

class GeoFence extends StatefulWidget {
  const GeoFence({Key? key}) : super(key: key);

  @override
  _GeoFenceState createState() => _GeoFenceState();
}

class _GeoFenceState extends State<GeoFence> {
  String geofencename = 'Home';
  double? long;
  double? lat;
  double? radius;

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
  void initState() {
    super.initState();
    //final placeApi = Provider.of<PlaceBloc>(context);
  }

  @override
  void dispose() {
    final placeApi = Provider.of<PlaceBloc>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final placeApi = Provider.of<PlaceBloc>(context);
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
                    onChanged: (value) => placeApi.searchPlaces(value),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        labelText: 'Location',
                        suffixIcon: Icon(Icons.search)),
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
