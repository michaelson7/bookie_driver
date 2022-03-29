import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../../constants/constants.dart';
import 'email_confirmation.dart';

class ForgotPassword extends StatelessWidget {
  static String id = "ForgotPassword";
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/shortBackground.png"),
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          buildContainer(context),
        ],
      ),
    );
  }

  buildContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(FontAwesome.angle_left, size: 30),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child:
                      Center(child: Image.asset("assets/images/ladylady.png")),
                ),
                Column(
                  children: [
                    Text(
                      "Forgot Password",
                      style: kTextStyleHeader1,
                    ),
                    Divider(color: Colors.grey),
                    Material(
                      borderRadius: kBorderRadiusCircular,
                      color: Colors.grey[200],
                      child: ListTile(
                        leading: Icon(FontAwesome.envelope),
                        title: TextField(
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Email',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 130),
          Expanded(
            child: Center(
              child: Text(
                "Enter the email or phone number registered to be sent the OTP number",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 35),
          SizedBox(
            width: double.infinity,
            child: InkWell(
              onTap: () {
                //Navigator.popAndPushNamed(context, MapActivity.id);
                Navigator.popAndPushNamed(context, EmailConfirmation.id);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: kBorderRadiusCircular,
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
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          FlatButton(
            color: Colors.transparent,
            onPressed: () {
              //   Navigator.pushNamed(context, ForgotPassword.id);
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
