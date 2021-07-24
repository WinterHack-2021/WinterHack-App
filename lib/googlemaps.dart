import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({Key? key}) : super(key: key);

  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

late GoogleMapController mapController;

final LatLng _center = const LatLng(45.521563, -122.677433);

void _onMapCreated(GoogleMapController controller) {
  mapController = controller;
}

class _GoogleMapsState extends State<GoogleMaps> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400,
        margin: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ))));
  }
}
