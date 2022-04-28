import 'package:bookie_driver/view/constants/constants.dart';
import 'package:bookie_driver/view/screens/activity/driver/DriverHomeInit.dart';
import 'package:bookie_driver/view/screens/activity/driver/vechileDetails.dart';
import 'package:bookie_driver/view/widgets/gradientButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../provider/shared_prefrence_provider.dart';
import '../../../constants/constants.dart';
import '../../../constants/enum.dart';
import 'driver_dashboard.dart';

class BusinessRegistration extends StatefulWidget {
  static String id = "DriverAccountDetails";
  const BusinessRegistration({Key? key}) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

// Navigator.popAndPushNamed(context, LoginActivity.id);
class _HomeActivityState extends State<BusinessRegistration> {
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
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
          ),
          SafeArea(child: buildContainer())
        ],
      ),
    );
  }

  buildContainer() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Corporate Account Details",
                style: kTextStyleWhite.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            options(hint: "FirstName"),
            options(hint: "LastName"),
            options(hint: "Personal oe business email"),
            options(hint: "Province,City"),
            options(hint: "Phone Number"),
            options(hint: "Skills"),
            options(hint: "Buisness Name"),
            options(hint: "Department"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: gradientButton(
                    function: () {
                      Navigator.popAndPushNamed(context, DriverHomeInit.id);
                    },
                    title: "SAVE",
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  options({required hint}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hint,
            style: kTextStyleWhite,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: TextField(
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: new InputDecoration(
                hintStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
