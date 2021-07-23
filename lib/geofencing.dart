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
  int geofenceid = 0;
  double long = 144.685666;
  double lat = -37.842921;
  int radius = 100;

  String geofenceState = 'N/A';
  ReceivePort port = ReceivePort();
  final List<GeofenceEvent> triggers = <GeofenceEvent>[
    GeofenceEvent.enter,
    GeofenceEvent.exit
  ];
  final AndroidGeofencingSettings androidSettings = AndroidGeofencingSettings(
      initialTrigger: <GeofenceEvent>[
        GeofenceEvent.enter,
        GeofenceEvent.exit,
        GeofenceEvent.dwell
      ],
      loiteringDelay: 1000 * 60);

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(
        port.sendPort, 'geofencing_send_port');
    port.listen((dynamic data) {
      print('Event: $data');
      setState(() {
        geofenceState = data;
      });
    });
    initPlatformState();
  }

  static void callback(List<String> ids, Location l, GeofenceEvent e) async {
    print('Fences: $ids Location $l Event: $e');
    final SendPort? send =
        IsolateNameServer.lookupPortByName('geofencing_send_port');
    send?.send(e.toString());
    print('Geofence Callback');
  }

  Future<void> initPlatformState() async {
    print('Initializing...');
    await GeofencingManager.initialize();
    print('Initialization done');
  }

  void addGeofence(geoid, long, lat, radius) {
    GeofencingManager.registerGeofence(
        GeofenceRegion('$geoid', lat, long, radius, triggers,
            androidSettings: androidSettings),
        callback);
    print('location $long $lat of radius: $radius added');
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
                    addGeofence(geofenceid, long, lat, radius);
                  },
                  child: Text('Add Location'))
            ],
          ),
        ));
  }
}
