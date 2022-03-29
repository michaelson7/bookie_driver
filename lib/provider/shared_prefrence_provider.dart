import 'package:shared_preferences/shared_preferences.dart';

import '../model/core/UserModel.dart';
import '../model/core/shared_preference_model.dart';
import '../view/constants/enum.dart';
import '../view/widgets/logger_widget.dart';

class SharedPreferenceProvider {
  SharedPreferenceModel sharedPreferenceModel = SharedPreferenceModel();

  addUserDetails(UserModel userModel) async {
    try {
      var userName = getEnumValue(UserDetails.userName);
      var userEmail = getEnumValue(UserDetails.userEmail);
      var userId = getEnumValue(UserDetails.userId);
      var userAccount = getEnumValue(UserDetails.userAccount);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(userName, userModel.firstName + " " + userModel.lastName);
      prefs.setString(userEmail, userModel.email);
      prefs.setString(userId, userModel.id);
    } catch (e) {
      loggerError(message: "Error on sharedPreferences: $e");
    }
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool userVal = prefs.containsKey("userName");
    return userVal;
  }

  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
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

  Future<String?> getStringValue(String value) async {
    try {
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
