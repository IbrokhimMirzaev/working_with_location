import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:working_with_location/data/repositories/repository.dart';

class LocationViewModel extends ChangeNotifier {
  LocationViewModel({required this.locationRepository});


  final LocationRepository locationRepository;

  String errorText = "";
  bool isLoading = false;
  Position? position;
  List<Placemark> placeMarks = [];
  List<Location> locationList = [];



  fetchCurrentPosition() async {
    notify(true);
    try {
      position = await locationRepository.determinePosition();
      if (position != null) {
        notify(false);
      }
    } catch (error) {
      errorText = error.toString();
    }
    notify(false);
  }

  fetchAddressFromLatLong() async {
    notify(true);
    try {
      if (position != null) {
        placeMarks = await locationRepository.getAddressFromLatLong(
            lat: position!.latitude, long: position!.longitude);
      }
      notify(false);
    } catch (error) {
      errorText = error.toString();
      print(errorText);
    }
    notify(false);
  }

  fetchLocationFromText({required String addressText}) async {
    notify(true);
    locationList = [];
    try {
      locationList = await locationRepository.getAddressFromText(addressText: addressText);
      notify(false);
    } catch (error) {
      errorText = error.toString();
      print(errorText);
    }
    notify(false);
  }

  notify(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
