// @dart=2.9
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../googlemaps.dart';
import '../placesapi.dart';

class GeoFencePage extends StatefulWidget {
  const GeoFencePage({Key key}) : super(key: key);

  @override
  _GeoFencePageState createState() => _GeoFencePageState();
}

class _GeoFencePageState extends State<GeoFencePage> {
  Completer<GoogleMapController> mapController = Completer();
  StreamSubscription locationSubscription;
  TextEditingController radiusController = new TextEditingController();
  TextEditingController locationtextController = new TextEditingController();
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

  Place currentPlace;

  @override
  void initState() {
    final placeBloc = Provider.of<PlaceBloc>(context, listen: false);
    getGeofences();

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

  dynamic currentgeofences;

  void getGeofences() async {
    currentgeofences = await bg.BackgroundGeolocation.geofences;
  }

  void locationtext(name) {
    locationtextController.text = '$name';
    print('name');
    locationtextController.selection = TextSelection.fromPosition(
      TextPosition(offset: locationtextController.text.length),
    );
    setState(() {});
  }

  bool show = true;

  Set<Circle> circles = Set.from(
      [Circle(circleId: CircleId('1'), radius: 0, center: LatLng(0, 0))]);

  Widget build(BuildContext context) {
    final placeBloc = Provider.of<PlaceBloc>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Locations'),
        ),
        body: Container(
            child: Column(children: [
          Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
              child: TextField(
                onTap: () {
                  show = true;
                },
                onChanged: (value) => placeBloc.searchPlaces(value),
                controller: locationtextController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Location',
                    suffixIcon: Icon(Icons.search)),
              )),
          Stack(children: [
            Column(children: [
              Container(
                  margin:
                      EdgeInsets.only(right: 10, left: 10, top: 8, bottom: 8),
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
            ]),
            if (placeBloc.searchResults != null &&
                placeBloc.searchResults.length != 0 &&
                show == true)
              Container(
                height: 200,
                margin: EdgeInsets.only(left: 10, right: 10, top: 0),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.6),
                    backgroundBlendMode: BlendMode.darken,
                    borderRadius: BorderRadius.circular(10)),
              ),
            if (placeBloc.searchResults != null &&
                placeBloc.searchResults.length != 0 &&
                show == true)
              Container(
                  height: 200,
                  margin: EdgeInsets.only(left: 10, right: 10, top: 0),
                  child: ListView.builder(
                    itemCount: placeBloc.searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(placeBloc.searchResults[index].description),
                        onTap: () {
                          var p = placeBloc.searchResults[index].description;
                          placeBloc.setSelectedLocation(
                              placeBloc.searchResults[index].placeId);
                          placeBloc.clearSearches();
                          locationtext(p);
                          placeBloc.clearSearches();
                          show = !show;
                        },
                      );
                    },
                  )),
          ]),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    if (radius != null)
                      addGeofence(
                          currentPlace.name,
                          currentPlace.geometry.location.lng,
                          currentPlace.geometry.location.lat,
                          radius);
                    setState(() {});
                  },
                  child: Text('Add Location')),
              Container(
                  child: TextButton(
                onPressed: () {},
                child: Text('Current Locations'),
              ))
              //ClickableLocationContainer(),  ],)
            ],
          ),
        ])));
  }

  Future<void> goToPlace(Place place) async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
            LatLng(place.geometry.location.lat, place.geometry.location.lng),
        zoom: 14.0)));
    setState(() {});
  }
}

void headlessTask(bg.HeadlessEvent headlessEvent) async {
  print('Started HeadlessTask: $headlessEvent');
  if (headlessEvent is bg.GeofenceEvent) {
    bg.GeofenceEvent geofenceEvent = headlessEvent.event;
    print('${geofenceEvent.action}');
    print('${geofenceEvent.identifier}');
  }
}
