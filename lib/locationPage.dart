import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class locationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
      title: Text('Locations Page'),
    ));
  }
}

// function to return location and check for enabled location services on andriod
get_location() async {
  var location = new Location();

  var serviceEnabled = await location.serviceEnabled();
  if (serviceEnabled == false) {
    serviceEnabled = await location.requestService();
    if (serviceEnabled = false) {
      return;
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }
}
