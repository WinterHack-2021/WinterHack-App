// @dart=2.9
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  Completer<GoogleMapController> mapController = Completer();
  StreamSubscription locationSubscription;
  TextEditingController radiusController = new TextEditingController();
  double radius;

  void addGeofence(geofencename, long, lat, radius) {
    bg.BackgroundGeolocation.addGeofence(bg.Geofence(
        notifyOnExit: true,
        notifyOnEntry: true,
        radius: radius,
        identifier: '$geofencename',
        latitude: lat,
        longitude: long));
    print('addded');
    print('Radius: $radius');
    print('Identifier: $geofencename');
  }

  Future<void> goToPlace(Place place) async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
            LatLng(place.geometry.location.lat, place.geometry.location.lng),
        zoom: 14.0)));
  }

  Place currentPlace;

  @override
  void initState() {
    final placeBloc = Provider.of<PlaceBloc>(context, listen: false);

    locationSubscription = placeBloc.selectedLocation.stream.listen((place) {
      if (place != null) {
        goToPlace(place);
        currentPlace = place;
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

  void setCircle(lat, lng, rad) {
    circles = Set.from([
      Circle(circleId: CircleId('1'), radius: rad, center: LatLng(lat, lng))
    ]);
  }

  Set<Circle> circles = Set.from(
      [Circle(circleId: CircleId('1'), radius: 0, center: LatLng(0, 0))]);

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
                    if (radius != null)
                      addGeofence(
                          currentPlace.name,
                          currentPlace.geometry.location.lng,
                          currentPlace.geometry.location.lat,
                          radius);
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
                    controller: radiusController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: 'Radius (m)'),
                    onSubmitted: (t) {
                      radius = double.parse(radiusController.text);
                      setCircle(currentPlace.geometry.location.lat,
                          currentPlace.geometry.location.lng, radius);
                      setState(() {});
                    },
                  )),
              (placeBloc.currentLocation == null)
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      height: 400,
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GoogleMap(
                              circles: circles,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              onMapCreated: (GoogleMapController controller) {
                                mapController.complete(controller);
                              },
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    placeBloc.currentLocation.latitude,
                                    placeBloc.currentLocation.longitude),
                                zoom: 11.0,
                              )))),
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
