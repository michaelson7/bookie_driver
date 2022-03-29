import 'package:bookie_driver/model/core/UserModel.dart';
import 'package:bookie_driver/provider/shared_prefrence_provider.dart';
import 'package:graphql/src/core/query_result.dart';

import '../model/core/UserDataModel.dart';
import '../view/constants/enum.dart';
import '../view/constants/mutations.dart';
import 'MutationProvider.dart';

class RegistrationProvider {
  Future<QueryResult> RegisterUser({required UserModel model}) async {
    var jsonBody = {
      "email": model.email,
      "phoneNumber": model.phoneNumber,
      "firstName": model.firstName,
      "lastName": model.lastName,
      "password": model.password,
    };
    var data = await MutationRequest(
      jsonBody: jsonBody,
      mutation: createAccount,
    );
    SharedPreferenceProvider sharedPreferenceProvider =
        SharedPreferenceProvider();
    await sharedPreferenceProvider.addUserDetails(model);
    return data;
  }

  Future<QueryResult> LoginUser({
    required number,
    required password,
  }) async {
    var jsonBody = {
      "password": password,
      "phoneNumber": number,
    };
    var data = await MutationRequest(
      jsonBody: jsonBody,
      mutation: tokenAuth,
    );
    var responseBody = data.data;
    var responseResult = responseBody!["tokenAuth"];
    bool responseVal = responseResult["success"];
    if (responseVal) {
      //get user data
      await setToken(responseResult);
      var response = await getUserId();
      UserDataModel userDataModel = UserDataModel.fromJson(
        response.data,
      );
      UserModel model = UserModel(
        email: userDataModel.me?.email ?? "",
        phoneNumber: userDataModel.me?.phoneNumber ?? "",
        firstName: userDataModel.me?.firstName ?? "",
        lastName: userDataModel.me?.lastName ?? "",
        password: "",
        id: userDataModel.me?.pk.toString() ?? "",
      );
      SharedPreferenceProvider sharedPreferenceProvider =
          SharedPreferenceProvider();
      await sharedPreferenceProvider.addUserDetails(model);
      //save token is shared prefrences

    }
    return data;
  }

  Future<QueryResult> verifyPhoneNumbers({
    required otp,
    required phoneNumber,
  }) async {
    var jsonBody = {
      "otp": otp,
      "phoneNumber": phoneNumber,
    };
    var data = await MutationRequest(
      jsonBody: jsonBody,
      mutation: verifyPhoneNumber,
    );
    return data;
  }

  Future<QueryResult> CreateDriver({required jsonBody}) async {
    var data = await MutationRequest(
      jsonBody: jsonBody,
      mutation: createDriver,
    );
    var responseBody = data.data;
    return data;
  }

  Future<QueryResult> refreshTokenRequest({
    required refreshTokenValue,
  }) async {
    var jsonBody = {
      "refreshToken": refreshTokenValue,
    };
    var data = await MutationRequest(
      jsonBody: jsonBody,
      mutation: refreshToken,
    );
    var responseBody = data.data;
    var response = responseBody!["refreshToken"];
    bool responseVal = response["success"];
    if (responseVal) {
      await setToken(response);
    }
    return data;
  }

  Future<QueryResult> getUserId() async {
    var data = await MutationRequest(
      jsonBody: {"": ""},
      mutation: me,
    );
    var responseBody = data.data;
    var response = responseBody!["me"];
    return data;
  }

  Future<void> setToken(response) async {
    var token = response["token"];
    var refreshToken = response["refreshToken"];
    SharedPreferenceProvider _sp = SharedPreferenceProvider();
    await _sp.setString(
      key: getEnumValue(Token.token),
      value: token,
    );
    await _sp.setString(
      key: getEnumValue(Token.refreshToken),
      value: refreshToken,
    );
  }
}
