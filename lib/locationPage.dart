import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class locationPage extends StatelessWidget {
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
  Future<Position> poscoord = _determinePosition();
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      TextButton(
          onPressed: () {
            setState(() {
              poscoord = _determinePosition();
            });
          },
          child: Text('Click for location')),
      Text(this.poscoord.toString())
    ]));
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}
