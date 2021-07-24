import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({Key? key}) : super(key: key);

  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

late GoogleMapController mapController;

void _onMapCreated(GoogleMapController controller) {
  mapController = controller;
}

class _GoogleMapsState extends State<GoogleMaps> {
  LatLng _center = LatLng(0, 0);
  double lat = 0;
  double long = 0;

  void initState() {
    super.initState();
    _center = LatLng(lat, long);
  }

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

class PlaceSearch {
  String description;
  String placeId;

  PlaceSearch({required this.description, required this.placeId});

  factory PlaceSearch.fromJson(Map<String, dynamic> json) {
    return PlaceSearch(
        description: json['description'], placeId: json['place_id']);
  }
}

class PlacesService {
  final key = 'YOUR_KEY';

  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$key';
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }

  Future<List<Place>> getPlaces(
      double lat, double lng, String placeType) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?location=$lat,$lng&type=$placeType&rankby=distance&key=$key';
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }
}

class Place {
  final Geometry geometry;
  final String name;
  final String vicinity;

  Place({required this.geometry, required this.name, required this.vicinity});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      geometry: Geometry.fromJson(json['geometry']),
      name: json['formatted_address'],
      vicinity: json['vicinity'],
    );
  }
}

class Geometry {
  final Location location;

  Geometry({required this.location});

  Geometry.fromJson(Map<dynamic, dynamic> parsedJson)
      : location = Location.fromJson(parsedJson['location']);
}

class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Location(lat: parsedJson['lat'], lng: parsedJson['lng']);
  }
}
