import 'package:bookie_driver/view/screens/activity/setup/password_reset.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import 'login_activity.dart';

class EmailConfirmation extends StatelessWidget {
  static String id = "EmailConfirmation";
  const EmailConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: buildContainer(context),
        ),
      ),
    );
  }

  buildContainer(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(child: Image.asset("assets/images/emailImg.png")),
        ),
        SizedBox(height: 60),
        Text(
          "Sent",
          style: kTextStyleHeader1,
        ),
        SizedBox(height: 10),
        Text(
          "We sent an OTP with a confirmation link to Pastoriasikalinda3@gmail.com",
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 100),
        SizedBox(
          width: 300,
          child: InkWell(
            onTap: () {
              Navigator.popAndPushNamed(context, PasswordReset.id);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(60)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF6A74CF),
                    Color(0xFFF18BE7),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    "Go Back",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
