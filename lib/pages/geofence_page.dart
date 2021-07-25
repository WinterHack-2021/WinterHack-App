// @dart=2.9
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:winterhack_2021/addedlocations.dart';
import 'package:flutter/cupertino.dart';
import 'package:winterhack_2021/data/schema.dart';
import 'package:winterhack_2021/data/shared_storage.dart';
import '../googlemaps.dart';
import '../placesapi.dart';

const platform = const MethodChannel('winterhack-channel');

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
  String savename;
  Place currentPlace;

  void addGeofence(String geofencename, double long, double lat, double radius,
      GlobalModel model) {
    bg.BackgroundGeolocation.addGeofence(bg.Geofence(
        notifyOnExit: true,
        notifyOnEntry: true,
        radius: radius,
        identifier: '$geofencename',
        latitude: lat,
        longitude: long));
    model.savedLocations
        .upsert(SavedLocation(lat, long, radius, geofencename, true));
  }

  @override
  void initState() {
    super.initState();
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

  var currentgeofences;

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
          backgroundColor: Colors.grey.shade900,
        ),
        body: Container(
            child: Column(children: [
          Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 0),
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
            (placeBloc.currentLocation == null)
                ? Center(child: CircularProgressIndicator())
                : Container(
                    height: 300,
                    margin: EdgeInsets.only(
                        top: 20, left: 10, right: 10, bottom: 10),
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
                              target: LatLng(placeBloc.currentLocation.latitude,
                                  placeBloc.currentLocation.longitude),
                              zoom: 11.0,
                            )))),
            if (placeBloc.searchResults != null &&
                placeBloc.searchResults.length != 0 &&
                show == true)
              Container(
                height: 200,
                margin: EdgeInsets.only(left: 10, right: 10, top: 0),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
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
          Column(children: [
            Container(
                height: 45,
                margin: EdgeInsets.only(right: 10, left: 10, top: 8, bottom: 8),
                child: TextField(
                  onChanged: (value) {
                    savename = value;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Save Name: This will appear in the app'),
                )),
            Container(
                height: 45,
                margin:
                    EdgeInsets.only(right: 10, left: 10, top: 8, bottom: 20),
                child: TextField(
                  controller: radiusController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Radius (m)'),
                  onChanged: (t) {
                    radius = double.parse(radiusController.text);
                    setCircle(currentPlace.geometry.location.lat,
                        currentPlace.geometry.location.lng, radius);
                    setState(() {});
                  },
                )),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<GlobalModel>(
                builder: (context, value, child) {
                  return Container(
                      margin: EdgeInsets.only(left: 0),
                      child: TextButton(
                          style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.all(Size(150, 60)),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.grey.shade700)),
                          onPressed: () {
                            if (radius != null && savename != null)
                              addGeofence(
                                  savename,
                                  currentPlace.geometry.location.lng,
                                  currentPlace.geometry.location.lat,
                                  radius,
                                  value);
                            setState(() {});
                          },
                          child: Text(
                            'Add Location',
                            style: TextStyle(color: Colors.white),
                          )));
                },
              ),
              Container(
                  margin: EdgeInsets.only(left: 20),
                  child: TextButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(150, 60)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey.shade700)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new CupertinoPageRoute(
                              builder: (ctxt) => AddedLocations()));
                    },
                    child: Text('Saved Locations',
                        style: TextStyle(color: Colors.white)),
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

    platform.invokeMethod("setEnabled", geofenceEvent.action == "ENTER");
  }
}
