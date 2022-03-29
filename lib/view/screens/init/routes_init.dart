import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/shared_prefrence_provider.dart';
import '../../constants/constants.dart';

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
            theme: buildThemeData(),
            //banner
            debugShowCheckedModeBanner: false,
            //routes
            initialRoute: isSigned ? DriverHomeInit.id : LoginActivity.id,
            routes: {
              DriverHomeInit.id: (context) => DriverHomeInit(),
              AddCard.id: (context) => AddCard(),
              CreatePaymentMEthods.id: (context) => CreatePaymentMEthods(),
              DriverPasswordReset.id: (context) => DriverPasswordReset(),
              DriverPicture.id: (context) => DriverPicture(),
              DriverOTP.id: (context) => DriverOTP(
                    phoneNumber: "",
                    password: "",
                  ),
              VechileDetails.id: (context) => VechileDetails(),
              DriverAccountDetails.id: (context) => DriverAccountDetails(),
              DriverSignUp.id: (context) => DriverSignUp(),
              IntroScreen.id: (context) => IntroScreen(),
              HomeActivity.id: (context) => HomeActivity(),
              LoginActivity.id: (context) => LoginActivity(),
              RegistrationActivity.id: (context) => RegistrationActivity(),
              MapActivity.id: (context) => MapActivity(),
              LocationSelectorActivity.id: (context) =>
                  LocationSelectorActivity(),
              TripSelection.id: (context) => TripSelection(
                    tripModel: TripModel(
                      startLatitude: "",
                      startLongitude: "",
                      endLongitude: "",
                      endLatitude: "",
                      userId: "",
                    ),
                  ),
              PaymentSelectionActivity.id: (context) =>
                  PaymentSelectionActivity(),
              DriverDashboard.id: (context) => DriverDashboard(),
              TripHistory.id: (context) => TripHistory(),
              TripHistoryPro.id: (context) => TripHistoryPro(),
              UserTrips.id: (context) => UserTrips(),
              TripDetails.id: (context) => TripDetails(),
              ForgotPassword.id: (context) => ForgotPassword(),
              EmailConfirmation.id: (context) => EmailConfirmation(),
              TripData.id: (context) => TripData(),
              TripComplete.id: (context) => TripComplete(),
              TripPending.id: (context) => TripPending(),
              PasswordReset.id: (context) => PasswordReset(),
              Prefrences.id: (context) => Prefrences(),
              TripDescription.id: (context) => TripDescription(),
              DriverScan.id: (context) => DriverScan(),
              OnTrip.id: (context) => OnTrip(),
              TripRating.id: (context) => TripRating(),
              ReportDriver.id: (context) => ReportDriver(),
              MessageScreen.id: (context) => MessageScreen(),
              CallScreen.id: (context) => CallScreen(),
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
