import 'dart:io';

import 'package:bookie_driver/view/screens/activity/driver/CallScreen.dart';
import 'package:bookie_driver/view/screens/activity/driver/DriverHomeInit.dart';
import 'package:bookie_driver/view/screens/activity/driver/BusinessRegistration.dart';
import 'package:bookie_driver/view/screens/activity/driver/driverOTP.dart';
import 'package:bookie_driver/view/screens/activity/driver/driver_dashboard.dart';
import 'package:bookie_driver/view/screens/activity/driver/driver_sign_up.dart';
import 'package:bookie_driver/view/screens/activity/driver/message_screen.dart';
import 'package:bookie_driver/view/screens/activity/driver/onTrip.dart';
import 'package:bookie_driver/view/screens/activity/home_activity.dart';
import 'package:bookie_driver/view/screens/activity/paymentSelection/payment_selection_activity.dart';
import 'package:bookie_driver/view/screens/activity/setup/email_confirmation.dart';
import 'package:bookie_driver/view/screens/activity/setup/introduction_screen.dart';
import 'package:bookie_driver/view/screens/activity/setup/login_activity.dart';
import 'package:bookie_driver/view/screens/activity/setup/password_reset.dart';
import 'package:bookie_driver/view/screens/activity/setup/registration_activity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
import '../../../model/service/NotificationService.dart';
import '../../../provider/shared_prefrence_provider.dart';
import '../../constants/constants.dart';
import '../../widgets/logger_widget.dart';
import '../activity/driver/DriverWallet.dart';
import '../activity/driver/contactUs.dart';
import '../activity/driver/driverPasswordReset.dart';
import '../activity/driver/driver_picture.dart';
import '../activity/driver/profileScreen.dart';
import '../activity/driver/vechileDetails.dart';
import '../activity/paymentSelection/addCard.dart';
import '../activity/setup/forgot_password.dart';

class RoutesInit extends StatefulWidget {
  const RoutesInit({Key? key}) : super(key: key);

  @override
  State<RoutesInit> createState() => _RoutesInitState();
}

class _RoutesInitState extends State<RoutesInit> {
  bool isLoading = true, isSigned = false;
  SharedPreferenceProvider _sharedPreferenceProvider =
      SharedPreferenceProvider();

  @override
  void initState() {
    checkIfSigned();
    super.initState();
  }

  Future<void> checkIfSigned() async {
    var signedState = await _sharedPreferenceProvider.isLoggedIn();
    setState(() {
      isSigned = signedState;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : MaterialApp(
            title: 'Bookie',
            navigatorKey: navigatorKey,
            theme: buildThemeData(),
            //banner
            debugShowCheckedModeBanner: false,
            //routes
            initialRoute: isSigned ? DriverHomeInit.id : LoginActivity.id,
            routes: {
              DriverHomeInit.id: (context) => DriverHomeInit(),
              DriverWallet.id: (context) => DriverWallet(),
              AddCard.id: (context) => AddCard(),
              DriverPasswordReset.id: (context) => DriverPasswordReset(),
              DriverPicture.id: (context) => DriverPicture(),
              DriverOTP.id: (context) => DriverOTP(
                    phoneNumber: "",
                    password: "",
                  ),
              VechileDetails.id: (context) => VechileDetails(),
              BusinessRegistration.id: (context) => BusinessRegistration(),
              DriverSignUp.id: (context) => DriverSignUp(),
              IntroScreen.id: (context) => IntroScreen(),
              HomeActivity.id: (context) => HomeActivity(),
              LoginActivity.id: (context) => LoginActivity(),
              RegistrationActivity.id: (context) => RegistrationActivity(),
              PaymentSelectionActivity.id: (context) =>
                  PaymentSelectionActivity(),
              ForgotPassword.id: (context) => ForgotPassword(),
              MessageScreen.id: (context) => MessageScreen(),
              CallScreen.id: (context) => CallScreen(),
              ProfileScreen.id: (context) => ProfileScreen(),
              ContactUs.id: (context) => ContactUs(),
            },
          );
  }

  ThemeData buildThemeData() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: kAccent,
      accentColor: kAccent,
      //scaffoldBackgroundColor: Colors.black,
      //buttons
      buttonTheme: ButtonThemeData(
        buttonColor: kAccent,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.0),
              //   side: BorderSide(color: Colors.red),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            kAccent,
          ), //button color
          foregroundColor: MaterialStateProperty.all<Color>(
            Color(0xffffffff),
          ), //text (and icon)
        ),
      ),
      //text
      fontFamily: 'Poppins',
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 15.0, fontFamily: 'Poppins'),
      ),
    );
  }
}
