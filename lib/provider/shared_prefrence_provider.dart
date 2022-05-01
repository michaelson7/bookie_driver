import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/core/UserModel.dart';
import '../model/core/shared_preference_model.dart';
import '../view/constants/enum.dart';
import '../view/widgets/logger_widget.dart';

class SharedPreferenceProvider {
  SharedPreferenceModel sharedPreferenceModel = SharedPreferenceModel();

  Future<UserModel> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var number = getEnumValue(UserDetails.number);
    var password = getEnumValue(UserDetails.password);
    UserModel userModel = UserModel(
      email: "email",
      photo: "",
      phoneNumber: prefs.getString(number) ?? "",
      firstName: "firstName",
      lastName: "lastName",
      password: prefs.getString(password) ?? "",
      id: "id",
    );
    return userModel;
  }

  addUserDetails(UserModel userModel) async {
    try {
      var userName = getEnumValue(UserDetails.userName);
      var userEmail = getEnumValue(UserDetails.userEmail);
      var userId = getEnumValue(UserDetails.userId);
      var number = getEnumValue(UserDetails.number);
      var password = getEnumValue(UserDetails.password);
      var userAccount = getEnumValue(UserDetails.userAccount);
      var userPhoto = getEnumValue(UserDetails.userPhoto);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(userName, userModel.firstName + " " + userModel.lastName);
      prefs.setString(userEmail, userModel.email);
      prefs.setString(number, userModel.phoneNumber);
      prefs.setString(password, userModel.password);
      prefs.setString(userId, userModel.id);
      prefs.setString(userPhoto, userModel.photo);
    } catch (e) {
      loggerError(message: "Error on sharedPreferences: $e");
    }
  }

  addOTPVerification() async {
    try {
      var data = getEnumValue(Register.hasAddedOTP);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(data, "TRUE");
    } catch (e) {
      loggerError(message: "Error on sharedPreferences: $e");
    }
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool userVal = prefs.containsKey("userName");
    return userVal;
  }

  Future<bool> isRegistrationOTPValid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(getEnumValue(TripType.tripType));
    if (data == getEnumValue(TripType.b2b)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isBusinessTrip() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = getEnumValue(Register.hasAddedOTP);
    bool userVal = prefs.containsKey(data);
    return userVal;
  }

  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("userName");
//    await preferences.clear();
  }

  setString({required String key, required String value}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (value != null) {
        prefs.setString(key, value);
      }
    } catch (e) {
      loggerError(message: 'Error on sharedPreferences [setString]: $e');
    }
  }

  setBool({required String key, required bool value}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (value != null) {
        prefs.setBool(key, value);
      }
    } catch (e) {
      loggerError(message: 'Error on sharedPreferences [setString]: $e');
    }
  }

  Future<bool?> getBoolValue(String value) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? spItem = prefs.getBool(value);
      return spItem;
    } catch (e) {
      loggerError(message: 'Error on sharedPreferences [getBoolValue]: $e');
    }
  }

  Future<String?> getStringValue(String value) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? spItem = prefs.getString(value);
      return spItem;
    } catch (e) {
      loggerError(message: 'Error on sharedPreferences [getStringValue]: $e');
    }
  }

  Future<int> getIntValue(String value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? spItem = prefs.getInt(value);
      if (spItem != null) {
        return spItem;
      } else {
        return 1;
      }
    } catch (e) {
      loggerError(message: 'Error on sharedPreferences [getStringValue]: $e');
      throw Exception('Error on sharedPreferences [getStringValue]: $e');
    }
  }

  Future<bool> checkIfDriver(String value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? spItem = prefs.getString(value);
      if (spItem == "driver") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      loggerError(message: 'Error on sharedPreferences [getStringValue]: $e');
      throw Exception('Error on sharedPreferences [getStringValue]: $e');
    }
  }

  //remove
  removeValue(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(value);
  }
}
