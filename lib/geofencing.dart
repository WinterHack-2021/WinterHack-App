import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geofencing/geofencing.dart';

class GeoFence extends StatefulWidget {
  const GeoFence({Key? key}) : super(key: key);

  @override
  _GeoFenceState createState() => _GeoFenceState();
}

class _GeoFenceState extends State<GeoFence> {
  String geofenceid = 'Geo_Fence_2';
  double long = 144.685666;
  double lat = -37.842921;
  double radius = 200;
  List<String> registeredGeofences = [];

  final List<GeofenceEvent> triggers = <GeofenceEvent>[
    GeofenceEvent.enter,
    GeofenceEvent.exit,
    GeofenceEvent.dwell
  ];
  final AndroidGeofencingSettings androidSettings = AndroidGeofencingSettings(
      initialTrigger: <GeofenceEvent>[
        GeofenceEvent.enter,
        GeofenceEvent.exit,
        GeofenceEvent.dwell
      ],
      loiteringDelay: 0);

  static void callback(List<String> ids, Location l, GeofenceEvent e) async {
    print('Geofence Callback');
    print('Fences: $ids Location $l Event: $e');
    final SendPort? send =
        IsolateNameServer.lookupPortByName('geofencing_send_port');
    send?.send(e.toString());
  }

  void addGeofence(geoid, long, lat, radius) {
    GeofencingManager.registerGeofence(
            GeofenceRegion('$geoid', lat, long, radius, triggers), callback)
        .then((_) {
      GeofencingManager.getRegisteredGeofenceIds().then((value) {
        setState(() {
          registeredGeofences = value;
        });
      });
    });

    print('location $long $lat of radius: $radius added');
    print(registeredGeofences);
  }

  void removeGeofence() {}

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
                    addGeofence(geofenceid, long, lat, radius);
                  },
                  child: Text('Add Location')),
              TextButton(
                onPressed: () async {
                  print(registeredGeofences);
                  var list = await GeofencingManager.getRegisteredGeofenceIds();
                  print(list);
                },
                child: Text('Print Registed Geofences'),
              )
            ],
          ),
        ));
  }
}
