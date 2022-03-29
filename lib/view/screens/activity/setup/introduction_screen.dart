import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:location/location.dart';
import '../../../../provider/location_provider.dart';
import '../../../widgets/toast.dart';
import 'login_activity.dart';

class IntroScreen extends StatelessWidget {
  static String id = "IntroScreen";

  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listPagesViewModel = [
      PageViewModel(
        title: "",
        body: "Bookie Helps you find, Comfortable cheap and safe rides",
        image: Image.asset("assets/images/cabImg.png", height: 175.0),
        decoration: pageModelDecoration(),
      ),
      PageViewModel(
        title: "",
        body:
            "With BOOKIE B2B, you are at liberty to choose  your business trip based on your Description",
        image: Image.asset("assets/images/map.png", height: 175.0),
        decoration: pageModelDecoration(),
      ),
      PageViewModel(
        title: "",
        body: "BOOKIE Helps you find, Comfortable cheap and safe ride.",
        image: Image.asset("assets/images/interview.png", height: 175.0),
        decoration: pageModelDecoration(),
      ),
      PageViewModel(
        title: "",
        body: "Please enable location permission",
        image: Image.asset("assets/images/locationPromt.png", height: 175.0),
        decoration: pageModelDecoration(),
      ),
    ];
    return MaterialApp(
      home: Container(
        child: IntroductionScreen(
          globalBackgroundColor: Color(0xFFD348AE),
          color: Colors.white,
          pages: listPagesViewModel,
          onChange: (index) {
            if (index == 3) {
              RequestPermission(context);
            }
            ;
          },
          onDone: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginActivity(),
              ),
              (route) => false,
            );
          },
          showSkipButton: true,
          skip: const Text("Skip"),
          next: const Icon(Icons.skip_next),
          done: const Text(
            "Done",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Colors.white,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }

  PageDecoration pageModelDecoration() {
    return const PageDecoration(
      bodyTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
      boxDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFAD29DA),
            Color(0xFFAD29DA),
            Color(0xFFAD29DA),
            Color(0xFFD348AE)
          ],
        ),
      ),
    );
  }
}

Future<void> RequestPermission(BuildContext context) async {
  LocationProvider _locationProvider = LocationProvider();
  var isLocationServiceEnabled = await _locationProvider.checkLocationService();
  if (!isLocationServiceEnabled) {
    //ask to turn on location
    toastMessage(
      context: context,
      message: "Please enable location service",
    );
  } else {
    PermissionStatus isLocationPermissionEnabled =
        await _locationProvider.checkLocationPermission();
    if (isLocationPermissionEnabled != PermissionStatus.granted) {
      //ask to enable location permission
      toastMessage(
        context: context,
        message: "Please enable location Permission",
      );
    }
  }
}
