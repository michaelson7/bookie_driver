import 'package:bookie_driver/view/constants/constants.dart';
import 'package:bookie_driver/view/widgets/gradientButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../provider/shared_prefrence_provider.dart';
import '../../../constants/enum.dart';
import 'driver_picture.dart';

class DriverPasswordReset extends StatefulWidget {
  static String id = "DriverPasswordReset";
  const DriverPasswordReset({Key? key}) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

// Navigator.popAndPushNamed(context, LoginActivity.id);
class _HomeActivityState extends State<DriverPasswordReset> {
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
          children: [
            SizedBox(height: 50),
            Text(
              "Create new Password",
              style: kTextStyleWhite,
            ),
            SizedBox(height: 20),
            options(hint: "Enter new password"),
            options(hint: "Confirm Password"),
            ListTile(
              leading: Checkbox(
                value: true,
                checkColor: kAccent,
                fillColor: MaterialStateProperty.all<Color>(Colors.white),
                onChanged: (value) {},
              ),
              title: Text("Remember Password"),
            ),
            SizedBox(height: 60),
            gradientButton(
              function: () {
                Navigator.popAndPushNamed(context, DriverPicture.id);
              },
              title: "Next",
            ),
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
