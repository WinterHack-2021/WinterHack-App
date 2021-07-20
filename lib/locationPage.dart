import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';

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

  static const platform = const MethodChannel('winterhack-channel');

  String? _placefields;

  Future<void> getPlaces() async {
    String? placefields;
    try {
      final dynamic result = await platform.invokeMethod('getcurrentlocation');
      print(result);
      placefields = '$result';
    } on PlatformException catch (e) {
      placefields = "Failed to get places: '${e.message}'.";
    }

    setState(() {
      _placefields = placefields;
    });
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

    Position userLocation = await Geolocator.getCurrentPosition();
    setState(() {
      position = userLocation;
    });
  }

  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      TextButton(
          onPressed: () {
            setState(() {
              _getUserPosition();
            });
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
            getPlaces();
          }),
      Container(child: Text(_placefields.toString()))
    ]));
  }
}
