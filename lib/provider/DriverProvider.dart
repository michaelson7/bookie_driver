import 'package:bookie_driver/view/constants/mutations.dart';
import 'package:graphql/src/core/query_result.dart';

import '../model/core/DriverAllTripModels.dart';
import '../model/core/DriverStatsModel.dart';
import '../model/core/TripDriverHistory.dart';
import '../model/core/carTypeModel.dart';
import '../model/core/dateFilterModel.dart';
import 'MutationProvider.dart';

class DriverProvider {
  Future<QueryResult> createDriverCar({required jsonBody}) async {
    var data = await MutationRequest(
      jsonBody: jsonBody,
      mutation: addDriverVehicle,
    );
    return data;
  }

  Future<QueryResult> updateDriverLocation({
    required jsonBody,
  }) async {
    var data = await MutationRequest(
      jsonBody: jsonBody,
      mutation: addDriverLocation,
    );
    return data;
  }

  Future<DriverAllTripHostory> getDriverTrips() async {
    var response = DriverAllTripHostory();
    var data = await MutationRequest(
      jsonBody: {
        "": "",
      },
      mutation: allMyTrips,
    );
    if (!data.hasException) {
      response = DriverAllTripHostory.fromJson(data.data!);
    }
    return response;
  }

  Future<DriverAllTripHostory> depositDriverFunds({
    required driverId,
    required amount,
  }) async {
    var response = DriverAllTripHostory();
    var data = await MutationRequest(
      jsonBody: {
        "driver": driverId,
        "amount": amount,
      },
      mutation: depositMoney,
    );
    if (!data.hasException) {
      //response = DriverAllTripHostory.fromJson(data.data!);
    }
    return response;
  }

  Future<DriverStatsModel> getDriverStats() async {
    var response = DriverStatsModel();
    var data = await MutationRequest(
      jsonBody: {
        "": "",
      },
      mutation: driverStats,
    );
    if (!data.hasException) {
      response = DriverStatsModel.fromJson(data.data!);
    }
    return response;
  }

  Future<QueryResult> driverArrivedAtDestination({
    required requestTripId,
  }) async {
    var response = DriverStatsModel();
    var data = await MutationRequest(
      jsonBody: {
        "requestTripId": requestTripId,
      },
      mutation: driverArrived,
    );
    if (!data.hasException) {
      //response = DriverStatsModel.fromJson(data.data!);
    }
    return data;
  }

  Future<CarTypeModel> getCarTypes() async {
    var response = CarTypeModel();
    var data = await MutationRequest(
      jsonBody: {
        "": "",
      },
      mutation: allVehicleClass,
    );
    if (!data.hasException) {
      response = CarTypeModel.fromJson(data.data!);
    }
    return response;
  }

  Future<TripDriverHistory> driverSpecificTrips() async {
    var response = TripDriverHistory();
    var data = await MutationRequest(
      jsonBody: {
        "": "",
      },
      mutation: driverTripsSelection,
    );
    if (!data.hasException) {
      response = TripDriverHistory.fromJson(data.data!);
    }
    return response;
  }

  Future<DateFilterModel> dateFilte({required filter}) async {
    var response = DateFilterModel();
    var data = await MutationRequest(
      jsonBody: {
        "filter": filter,
      },
      mutation: dateFilter,
    );
    if (!data.hasException) {
      response = DateFilterModel.fromJson(data.data!);
    }
    return response;
  }
}
