import 'package:flutter/cupertino.dart';
import 'package:graphql/src/core/query_result.dart';
import '../model/core/AcceptTripModel.dart';
import '../model/core/AddTripModel.dart';
import '../model/core/AddTripResponse.dart';
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
      response = TripListModel.fromJson(data.data!);
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

  Future<AcceptTripModel> driverAcceptTrip({
    required driverId,
    required requestTripId,
  }) async {
    AcceptTripModel response = AcceptTripModel();
    var data = await MutationRequest(
      jsonBody: {
        "requestTripId": requestTripId,
        "driverId": driverId,
      },
      mutation: addAcceptTrip,
    );
    if (!data.hasException) {
      response = AcceptTripModel.fromJson(data.data);
    }
    return response;
  }

  Future<AddTripResponse> addTripData({
    required acceptId,
    required endLocationName,
    required endLocationLatituide,
    required endLocationLongitude,
    required startLocationName,
    required startLocationLatituide,
    required startLocationLongitude,
  }) async {
    var response = AddTripResponse();
    var data = await MutationRequest(
      jsonBody: {
        "acceptId": acceptId,
        "endLocationName": endLocationName,
        "endLocationLatituide": endLocationLatituide,
        "endLocationLongitude": endLocationLongitude,
        "startLocationName": startLocationName,
        "startLocationLatituide": startLocationLatituide,
        "startLocationLongitude": startLocationLongitude,
      },
      mutation: addTrip,
    );
    if (!data.hasException) {
      response = AddTripResponse.fromJson(data.data);
    }
    return response;
  }
}
