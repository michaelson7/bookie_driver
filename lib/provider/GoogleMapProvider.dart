import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:bookie_driver/view/widgets/directions_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:gql_http_link/gql_http_link.dart';
import 'dart:convert' as convert;

import '../model/core/MapsResult.dart';
import '../view/widgets/.env.dart';
import '../view/widgets/logger_widget.dart';
import 'dart:ui' as ui;

class GoogleMapsProvider {
  final CameraPosition defaultDestination = CameraPosition(
    target: LatLng(-15.3868807, 28.6478416),
    zoom: 18.4746, //21 max
  );

  Future<void> goToDestinations({
    required Completer<GoogleMapController> controllerData,
    required Directions? directionsInformation,
  }) async {
    final GoogleMapController controller = await controllerData.future;
    controller.animateCamera(
      directionsInformation == null
          ? CameraUpdate.newCameraPosition(defaultDestination)
          : CameraUpdate.newLatLngBounds(directionsInformation.bounds, 100.0),
    );
  }

  Future<Marker> addUserLocationData({
    required LocationData userLocation,
    required Completer<GoogleMapController> controllerData,
    bool zoom = true,
  }) async {
    LatLng location = LatLng(
      userLocation.latitude ?? 0,
      userLocation.longitude ?? 0,
    );
    CameraPosition locationData;
    if (zoom) {
      locationData = CameraPosition(
        target: location,
        zoom: 18, //21 max
      );
    } else {
      locationData = CameraPosition(
        target: location,
        zoom: 18.4746, //21 max
      );
    }

    final GoogleMapController controller = await controllerData.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(locationData),
    );
    return addMarker(
      pos: location,
      isDestination: false,
    );
  }

  Future<Marker> setTaxiLocation({
    required LatLng pos,
    required name,
    required Completer<GoogleMapController> controllerData,
  }) async {
    final Uint8List markerIcon = await getBytesFromAsset(
      'assets/images/carU.png',
      100,
    );
    return Marker(
      markerId: MarkerId(name),
      infoWindow: InfoWindow(title: name),
      icon: BitmapDescriptor.fromBytes(markerIcon),
      position: pos,
    );
  }

  Future<Marker> addMarker({
    required LatLng pos,
    required bool isDestination,
  }) async {
    if (!isDestination) {
      final Uint8List markerIcon = await getBytesFromAsset(
        'assets/images/Pickup.png',
        100,
      );
      return Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        position: pos,
      );
    } else {
      final Uint8List markerIcon = await getBytesFromAsset(
        'assets/images/LocationMarker.png',
        100,
      );
      return Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        position: pos,
      );
    }
  }

  Future<Directions?> getDirections({
    required LatLng pos,
    required Marker originMarker,
  }) async {
    // Get directions
    Dio dio = Dio();
    final directions = await DirectionsRepository(dio: dio).getDirections(
      origin: originMarker.position,
      destination: pos,
    );
    return directions;
  }

  Future<MapsResult> searchForPlace(String input) async {
    input = input + "in lusaka zambia";
    var url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?query=$input&key=$googleAPIKey";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    MapsResult result = MapsResult.fromJson(json);
    return result;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
