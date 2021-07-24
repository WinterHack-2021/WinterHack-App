// @dart=2.9
import 'dart:async';
import 'main.dart';
import 'package:flutter/material.dart';
import 'googlemaps.dart';
import 'clickable_container.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'placesapi.dart';
import 'package:provider/provider.dart';

class GeoFence extends StatefulWidget {
  const GeoFence({Key key}) : super(key: key);

  @override
  _GeoFenceState createState() => _GeoFenceState();
}

class _GeoFenceState extends State<GeoFence> {
  String geofencename = 'Home';
  double long = 0;
  double lat = 0;
  double radius = 10;

  void addGeofence(geofencename, long, lat, radius) {
    bg.BackgroundGeolocation.addGeofence(bg.Geofence(
        notifyOnExit: true,
        notifyOnEntry: true,
        radius: radius,
        identifier: '$geofencename',
        latitude: lat,
        longitude: long));
    print('addded');
  }

  StreamSubscription locationSubscription;

  dynamic googleMap = GoogleMaps();
  @override
  void initState() {
    final placeBloc = Provider.of<PlaceBloc>(context, listen: false);

    locationSubscription = placeBloc.selectedLocation.stream.listen((place) {
      if (place != null) {
        googleMap.goToPlace(place);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    final placeBloc = Provider.of<PlaceBloc>(context, listen: false);
    placeBloc.dispose();
    locationSubscription.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final placeBloc = Provider.of<PlaceBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Locations'),
        ),
        body: Container(
          child: ListView(
            children: [
              TextButton(
                  onPressed: () {
                    addGeofence(geofencename, long, lat, radius);
                  },
                  child: Text('Add Location')),
              Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) => placeBloc.searchPlaces(value),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: 'Location',
                        suffixIcon: Icon(Icons.search)),
                  )),
              if (placeBloc.searchResults != null &&
                  placeBloc.searchResults.length != 0)
                Stack(children: [
                  Container(
                    height: 200,
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.3),
                        backgroundBlendMode: BlendMode.darken,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  Container(
                      height: 200,
                      margin: EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: placeBloc.searchResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                placeBloc.searchResults[index].description),
                            onTap: () {
                              placeBloc.setSelectedLocation(
                                  placeBloc.searchResults[index].placeId);
                            },
                          );
                        },
                      ))
                ]),
              Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: 'Radius (m)'),
                  )),
              googleMap,
              //ClickableLocationContainer(),
            ],
          ),
        ));
  }
}

void headlessTask(bg.HeadlessEvent headlessEvent) async {
  print('Started HeadlessTask: $headlessEvent');
  bg.GeofenceEvent geofenceEvent = headlessEvent.event;
  print('${geofenceEvent.action}');
  print('${geofenceEvent.identifier}');
}
