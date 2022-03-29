import 'package:flutter/cupertino.dart';
import 'package:graphql/src/core/query_result.dart';
import '../model/core/AddTripModel.dart';
import '../model/core/TripListModel.dart';
import '../model/core/TripUpdateModel.dart';
import '../model/core/UserTripData.dart';
import '../view/constants/mutations.dart';
import 'MutationProvider.dart';
import 'geoLocatorProvider.dart';

class TripProvider extends ChangeNotifier {
  GeoLocatorProvider geoLocatorProvider = GeoLocatorProvider();

  Future<AddTripModel> createRequestTrip({required jsonBody}) async {
    AddTripModel response = AddTripModel();
    var data = await MutationRequest(
      jsonBody: jsonBody,
      mutation: addRequestTrip,
    );
    if (!data.hasException) {
      response = AddTripModel.fromJson(data.data);
    }
    return response;
  }

  Future<TripListModel> allTripRequests({
    required jsonBody,
  }) async {
    TripListModel response = TripListModel();
    var data = await MutationRequest(
      jsonBody: jsonBody,
      mutation: allRequestTrip,
    );
    if (!data.hasException) {
      response = TripListModel.fromJson(data.data);
      for (var data in response.allRequestTrip!) {
        var location = await geoLocatorProvider.getUserLocation(
          latitude: double.parse(data.pickupLocation?.latitude ?? ""),
          longitude: double.parse(data.pickupLocation?.longitude ?? ""),
        );
        data.pickupLocation?.LocationName =
            "${location.street}, ${location.subLocality}";

        location = await geoLocatorProvider.getUserLocation(
          latitude: double.parse(data.endLocation?.latitude ?? ""),
          longitude: double.parse(data.endLocation?.longitude ?? ""),
        );

        data.endLocation?.LocationName =
            "${location.street}, ${location.subLocality}";
      }
    }
    return response;
  }

  Future<UserTripData> tripRequestData({
    required jsonBody,
  }) async {
    UserTripData response = UserTripData();
    var data = await MutationRequest(
      jsonBody: jsonBody,
      mutation: requestTripInfo,
    );
    if (!data.hasException) {
      response = UserTripData.fromJson(data.data);
    }
    return response;
  }

  Future<TripUpdateModel> updateTripData({
    required jsonBody,
  }) async {
    TripUpdateModel response = TripUpdateModel();
    var data = await MutationRequest(
      jsonBody: jsonBody,
      mutation: updateRequestTrip,
    );
    if (!data.hasException) {
      response = TripUpdateModel.fromJson(data.data);
    }
    return response;
  }
}
