import 'package:bookie_driver/view/constants/mutations.dart';
import 'package:graphql/src/core/query_result.dart';

import '../model/core/carTypeModel.dart';
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
}
