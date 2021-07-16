import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class locationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Flutter Geolocation')),
      body: Container(),
    );
  }
}

// class locationPager extends State {
//   var _geolocator;
//   var _position;

//   void checkPermission() {
//     _geolocator.checkGeolocationPermissionStatus().then((status) {
//       print('status: $status');
//     });
//     _geolocator
//         .checkGeolocationPermissionStatus(
//             locationPermission: GeolocationPermission.locationAlways)
//         .then((status) {
//       print('always status: $status');
//     });
//     _geolocator.checkGeolocationPermissionStatus(
//         locationPermission: GeolocationPermission.locationWhenInUse)
//       ..then((status) {
//         print('whenInUse status: $status');
//       });
//   }

//   @override
//   void initState() {
//     super.initState();

//     _geolocator = Geolocator();
//     LocationOptions locationOptions =
//         LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);

//     checkPermission();
//     //    updateLocation();

//     var positionStream = _geolocator
//         .getPositionStream(locationOptions)
//         .listen((Position position) {
//       _position = position;
//     });
//   }

//   void updateLocation() async {
//     try {
//       Position newPosition = await Geolocator()
//           .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//           .timeout(new Duration(seconds: 5));

//       setState(() {
//         _position = newPosition;
//       });
//     } catch (e) {
//       print('Error: ${e.toString()}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Startup Name Generator'),
//       ),
//       body: Center(
//           child: Text(
//               'Latitude: ${_position != null ? _position.latitude.toString() : '0'},'
//               ' Longitude: ${_position != null ? _position.longitude.toString() : '0'}')),
//     );
//   }
// }

// class GeolocationExample extends StatefulWidget {
//   @override
//   locationPager createState() => new locationPager();
// }

// // function to return location and check for enabled location services on andriod
// get_location() async {
//   var location = new Location();

//   var serviceEnabled = await location.serviceEnabled();
//   if (serviceEnabled == false) {
//     serviceEnabled = await location.requestService();
//     if (serviceEnabled = false) {
//       return;
//     }
//   }
//   var permissionGranted = await location.hasPermission();
//   if (permissionGranted == PermissionStatus.denied) {
//     permissionGranted = await location.requestPermission();
//     if (permissionGranted != PermissionStatus.granted) {
//       return;
//     }
//   }
//   var location_data = location.getLocation();
// }
