import 'package:geocoding/geocoding.dart';

class GeoLocatorProvider {
  Future<Placemark> getUserLocation(
      {required double latitude, required double longitude}) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
    );
    return placemarks[0];
  }
}
