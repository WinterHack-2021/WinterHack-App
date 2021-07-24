import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'geofencing.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';

const platform = const MethodChannel('winterhack-channel');

String? _placefields;

getPlaces2() async {
  String placefields;
  try {
    final dynamic result = await platform.invokeMethod('getcurrentlocation');
    placefields = '$result';
  } on PlatformException catch (e) {
    placefields = "Failed to get places: '${e.message}'.";
  }
  _placefields = placefields;
}

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Flutter Geolocation'),
          elevation: 0,
        ),
        body: Container(child: Column(children: [LocationBox()])));
  }
}

class LocationBox extends StatefulWidget {
  @override
  _LocationBoxState createState() => _LocationBoxState();
}

class _LocationBoxState extends State<LocationBox> {
  Position? position;

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  String? _placefields;

  Future<void> getPlaces() async {
    getPlaces2();
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      TextButton(
          onPressed: () {
            setState(() {});
          },
          child: Text('Click for location')),
      Text(this.position.toString()),
      Container(
        width: 200,
        height: 200,
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
      TextButton(
          child: Text('Get Places'),
          onPressed: () {
            setState(() {
              getPlaces();
            });
          }),
      Container(child: Text(_placefields.toString()))
    ]));
  }
}
