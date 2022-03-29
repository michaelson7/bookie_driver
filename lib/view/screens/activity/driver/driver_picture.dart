import 'package:bookie_driver/view/screens/activity/driver/vechileDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../provider/shared_prefrence_provider.dart';
import '../../../constants/constants.dart';
import '../../../constants/enum.dart';
import '../../../widgets/gradientButton.dart';
import 'driverPasswordReset.dart';

class DriverPicture extends StatefulWidget {
  static String id = "DriverPicture";
  const DriverPicture({Key? key}) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

// Navigator.popAndPushNamed(context, LoginActivity.id);
class _HomeActivityState extends State<DriverPicture> {
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
            Container(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                  ),
                ),
              ),
              height: MediaQuery.of(context).size.width - 220,
              width: MediaQuery.of(context).size.width - 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: AssetImage('assets/images/1234.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              "Add profile picture",
              style: kTextStyleWhite,
            ),
            SizedBox(height: 20),
            options(
              hint: "License ID",
              hintPro: "Front",
              showIcon: true,
            ),
            options(
              hint: "LicenseID",
              hintPro: "Black",
              showIcon: true,
            ),
            options(
              hint: "Address",
              hintPro: "",
            ),
            SizedBox(height: 60),
            gradientButton(
              function: () {
                Navigator.popAndPushNamed(context, VechileDetails.id);
              },
              title: "Login",
            ),
          ],
        ),
      ),
    );
  }

  options({
    required hint,
    required hintPro,
    bool showIcon = false,
  }) {
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
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: new InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.grey,
                        border: InputBorder.none,
                        hintText: hintPro,
                      ),
                    ),
                  ),
                ),
                showIcon
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
