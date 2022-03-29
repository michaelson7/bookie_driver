import 'package:bookie_driver/view/constants/constants.dart';
import 'package:bookie_driver/view/screens/activity/driver/DriverHomeInit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'email_confirmation.dart';
import 'forgot_password.dart';

class PasswordReset extends StatefulWidget {
  static String id = "PasswordReset";
  const PasswordReset({Key? key}) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<PasswordReset> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAccent,
        title: Text(
          "Forgot Password",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
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

  Widget buildContainer() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text("4 DIGIT NUMBER")),
            optSection(),
            passwordSection(),
            SizedBox(height: 10),
            passwordStregth(),
            SizedBox(height: 40),
            SubmitButton()
          ],
        ),
      ),
    );
  }

  optSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: OTPTextField(
        length: 4,
        width: MediaQuery.of(context).size.width,
        fieldWidth: 60,
        style: TextStyle(fontSize: 15),
        otpFieldStyle: OtpFieldStyle(backgroundColor: Colors.white),
        //textFieldAlignment: MainAxisAlignment.spaceAround,
        fieldStyle: FieldStyle.box,
        onCompleted: (pin) {
          print("Completed: " + pin);
        },
      ),
    );
  }

  passwordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text("ENTER NEW PASSWORD"),
        SizedBox(height: 8),
        Material(
          borderRadius: kBorderRadiusCircularPro,
          color: Colors.grey[200],
          child: ListTile(
            leading: Icon(FontAwesome.eye, color: Colors.black),
            title: TextField(
              obscureText: true,
            ),
          ),
        ),
        SizedBox(height: 20),
        Text("ENTER NEW PASSWORD"),
        SizedBox(height: 10),
        Material(
          borderRadius: kBorderRadiusCircularPro,
          color: Colors.grey[200],
          child: ListTile(
            leading: Icon(FontAwesome.eye, color: Colors.black),
            title: TextField(obscureText: true),
          ),
        ),
      ],
    );
  }

  passwordStregth() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: stepper(title: "Weak", color: Color(0xFFFD749B)),
          ),
          Expanded(
            child: stepper(title: "Average"),
          ),
          Expanded(
            child: stepper(title: "Strong"),
          ),
        ],
      ),
    );
  }

  Column stepper({required title, Color color = Colors.white24}) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: color == Colors.grey
                ? BorderRadius.all(Radius.circular(0))
                : kBorderRadiusCircular,
            color: color,
          ),
          height: color == Colors.grey ? 8 : 12,
        ),
        Text(title),
      ],
    );
  }

  SubmitButton() {
    return InkWell(
      onTap: () {
        Navigator.popAndPushNamed(context, DriverHomeInit.id);
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
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
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
