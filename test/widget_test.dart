import 'package:bookie_driver/model/core/UserModel.dart';
import 'package:bookie_driver/provider/DriverProvider.dart';
import 'package:bookie_driver/provider/RegistrationProvider.dart';
import 'package:bookie_driver/provider/TripProvider.dart';
import 'package:bookie_driver/view/widgets/logger_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookie_driver/main.dart';

main() {
  test('RefreshToken', () async {
    RegistrationProvider _provider = RegistrationProvider();
    var refreshToken = "dcce401416c1c5e729a583a44415c045ccdb4f11";
    await _provider.refreshTokenRequest(refreshTokenValue: refreshToken);
  });

  test('LoginUser', () async {
    RegistrationProvider _provider = RegistrationProvider();
    await _provider.LoginUser(
      number: "0978905095",
      password: "Password123!",
    );
  });

  test('RegisterUser', () async {
    RegistrationProvider _provider = RegistrationProvider();
    await _provider.RegisterUser(
      model: UserModel(
        id: "dd",
        photo: "",
        email: "lisa@email.com",
        phoneNumber: "0954512435",
        firstName: "lisa",
        lastName: "simone",
        password: "Password123!",
      ),
    );
  });

  test('verifyPhoneNumber', () async {
    RegistrationProvider _provider = RegistrationProvider();
    await _provider.verifyPhoneNumbers(
      otp: "0411",
      phoneNumber: "0954512435",
    );
  });

  test('getUserData', () async {
    RegistrationProvider _provider = RegistrationProvider();
    await _provider.getUserId();
  });

  test('depositFunds', () async {
    var _provider = DriverProvider();
    await _provider.depositDriverFunds(
      driverId: "3",
      amount: "2000",
    );
  });

  test('driverAcceptTrip', () async {
    TripProvider _provider = TripProvider();
    var response = await _provider.driverAcceptTrip(
      driverId: "3",
      requestTripId: "126",
    );
  });

  test('addTrip', () async {
    TripProvider _provider = TripProvider();
    var response = await _provider.addTripData(
      acceptId: "33",
      endLocationName: "end location",
      endLocationLatituide: "5323",
      endLocationLongitude: "6544",
      startLocationName: "start name",
      startLocationLatituide: "455",
      startLocationLongitude: "624",
    );
  });

  test('allTripRequests', () async {
    TripProvider _provider = TripProvider();
    var jsonBody = {
      "": "",
    };
    var response = await _provider.allTripRequests(jsonBody: jsonBody);
    // loggerInfo(message: response.toJson().toString());
  });

  test('allCarType', () async {
    var _provider = DriverProvider();
    var response = await _provider.getCarTypes();
  });

  //
  test('getDriverTrips', () async {
    var _provider = DriverProvider();
    var response = await _provider.getDriverTrips();
  });

  test('driverArrivedAtDestination', () async {
    var _provider = DriverProvider();
    var response = await _provider.driverArrivedAtDestination(
      requestTripId: 202,
    );
  });

  test('getDriverStats', () async {
    var _provider = DriverProvider();
    var response = await _provider.getDriverStats();
  });

  test('driverSpecifcTrips', () async {
    var _provider = DriverProvider();
    var response = await _provider.driverSpecificTrips();
  });

  test('dateFilte', () async {
    var _provider = DriverProvider();
    var response = await _provider.dateFilte(filter: "week");
  });

  test('updateTripRequest', () async {
    var _provider = TripProvider();
    var response = await _provider.updateTripRequest(
      tripId: "14",
      amount: "500",
      distance: "10",
      name: "woodlands",
      latitude: "100",
      longitude: "200",
    );
  });

  test('testTIme', () async {
    var d = Duration(minutes: 25);
    loggerAccent(message: d.inHours.toString());
  });
  //
}
