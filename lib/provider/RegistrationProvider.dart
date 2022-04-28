import 'package:bookie_driver/provider/shared_prefrence_provider.dart';
import 'package:graphql/src/core/query_result.dart';
import '../model/core/UploadPhotoResponse.dart';
import '../model/core/UserDataModel.dart';
import '../model/core/UserModel.dart';
import '../model/core/driverResponseModel.dart';
import '../model/core/forgotPasswordResponse.dart';
import '../model/core/resetPasswordResponse.dart';
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
        response.data!,
      );
      UserModel model = UserModel(
        email: userDataModel.me?.email ?? "",
        phoneNumber: userDataModel.me?.phoneNumber ?? "",
        firstName: userDataModel.me?.firstName ?? "",
        lastName: userDataModel.me?.lastName ?? "",
        password: password,
        photo: userDataModel.me!.profilepictureSet!.isNotEmpty
            ? "${userDataModel.me?.profilepictureSet?.first.image}"
            : "",
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

  Future<DriverResponseModel> CreateDriver({required jsonBody}) async {
    DriverResponseModel response = DriverResponseModel();
    var data = await MutationRequest(
      jsonBody: jsonBody,
      mutation: createDriver,
    );
    if (!data.hasException) {
      response = DriverResponseModel.fromJson(data.data!);
    }
    return response;
  }

  Future<ForgotPasswordResponse> forgotPasswords({required email}) async {
    ForgotPasswordResponse response = ForgotPasswordResponse();
    var data = await MutationRequest(
      jsonBody: {
        "email": email,
      },
      mutation: forgotPassword,
    );
    if (!data.hasException) {
      response = ForgotPasswordResponse.fromJson(data.data!);
    }
    return response;
  }

  Future<ResetPasswordResponse> resetPasswords({
    required email,
    required otp,
    required password1,
    required password2,
  }) async {
    ResetPasswordResponse response = ResetPasswordResponse();
    var data = await MutationRequest(
      jsonBody: {
        "email": email,
        "otp": otp,
        "password1": password1,
        "password2": password2,
      },
      mutation: resetPassword,
    );
    if (!data.hasException) {
      response = ResetPasswordResponse.fromJson(data.data!);
    }
    return response;
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

  Future<UploadPhotoResponse> updateProfilePhoto({
    required userId,
    required photo,
  }) async {
    UploadPhotoResponse response = UploadPhotoResponse();
    var data = await MutationRequest(
      jsonBody: {
        "user": userId,
        "image": photo,
      },
      mutation: uploadProfilePicture,
    );
    if (!data.hasException) {
      response = UploadPhotoResponse.fromJson(data.data!);
    }
    return response;
  }

  Future<QueryResult> updateAccountData({
    required userId,
    required firstName,
    required lastName,
    required email,
  }) async {
    var data = await MutationRequest(
      jsonBody: {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
      },
      mutation: updateAccount,
    );
    var responseBody = data.data;
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
