import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'geofencing.dart';
import 'googlemaps.dart';

class PlaceBloc with ChangeNotifier {
  final placesService = PlacesService();

  Position? currentLocation;

  List<PlaceSearch>? searchResults;

  PlaceApi() {
    _getUserPosition();
  }

  _getUserPosition() async {
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

    Position userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentLocation = userLocation;
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }
}
