import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
      Text(this.position.toString())
    ]));
  }
}
