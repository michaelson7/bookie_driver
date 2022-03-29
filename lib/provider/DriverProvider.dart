import 'package:bookie_driver/view/constants/mutations.dart';
import 'package:graphql/src/core/query_result.dart';

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
}
