import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

import '../view/widgets/toast.dart';

class LocationProvider {
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<bool> checkLocationService() async {
    Location location = new Location();
    bool _serviceEnabled;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        _serviceEnabled = false;
      }
    }
    return _serviceEnabled;
  }

  Future<PermissionStatus> checkLocationPermission() async {
    PermissionStatus _permissionGranted;
    Location location = new Location();

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        _permissionGranted == PermissionStatus.denied;
      }
    }
    return _permissionGranted;
  }

  Future<LocationData?> getUserLocation(BuildContext context) async {
    LocationData? position;
    Location location = new Location();
    var isLocationServiceEnabled = await checkLocationService();
    if (!isLocationServiceEnabled) {
      //ask to turn on location
      toastMessage(
        context: context,
        message: "Please enable location service",
      );
    } else {
      PermissionStatus isLocationPermissionEnabled =
          await checkLocationPermission();
      if (isLocationPermissionEnabled != PermissionStatus.granted) {
        toastMessage(
          context: context,
          message: "Please enable location Permission",
        );
      } else {
        position = await location.getLocation();
      }
      return position;
    }
  }
}
