import 'dart:convert';

import 'package:bookie_driver/view/screens/activity/setup/registration_activity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../provider/RegistrationProvider.dart';
import '../../../../provider/shared_prefrence_provider.dart';
import '../../../constants/constants.dart';
import '../../../constants/mutations.dart';

import '../../../widgets/PopUpDialogs.dart';
import '../../../widgets/gradientButton.dart';
import '../../../widgets/signOptionsPro.dart';
import '../../../widgets/toast.dart';
import '../driver/DriverHomeInit.dart';
import '../driver/driver_dashboard.dart';
import '../driver/driver_sign_up.dart';
import 'email_confirmation.dart';
import 'forgot_password.dart';

class LoginActivity extends StatefulWidget {
  static String id = "LoginActivity";
  const LoginActivity({Key? key}) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

//AssetImage("assets/images/loginBackground.png")+
class _HomeActivityState extends State<LoginActivity> {
  TextEditingController userNameController = TextEditingController(),
      passwordController = TextEditingController();
  SharedPreferenceProvider _sharedPreferenceProvider =
      SharedPreferenceProvider();
  final _formKey = GlobalKey<FormState>();
  bool isDriverSignUp = true;

  @override
  void initState() {
    passwordController.text = "Password123!";
    userNameController.text = "0954512435";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/shortBackground.png"),
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          buildContainer(),
        ],
      ),
    );
  }

  Widget buildContainer() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            loginBody(),
            // Expanded(child: Container()),
            registrationBody(),
          ],
        ),
      ),
    );
  }

  Widget loginBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/logo.png", height: 160.0),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Material(
                  borderRadius: kBorderRadiusCircular,
                  color: Colors.grey[200],
                  child: ListTile(
                    leading: Icon(FontAwesome.user, color: Colors.black),
                    title: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Add Phone Number";
                        }
                        return null;
                      },
                      controller: userNameController,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Phone Number',
                      ),
                    ),
                  ),
                ),
                Divider(color: Colors.grey),
                Material(
                  borderRadius: kBorderRadiusCircular,
                  color: Colors.grey[200],
                  child: ListTile(
                    leading: Icon(FontAwesome.eye, color: Colors.black),
                    title: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Add Password";
                        }
                        return null;
                      },
                      controller: passwordController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      obscureText: true,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Password',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 35),
          SizedBox(
            width: double.infinity,
            child: gradientButton(
              function: () async {
                await RegisterUser();
              },
              title: "Login",
            ),
          ),
          FlatButton(
            color: Colors.transparent,
            onPressed: () {
              Navigator.pushNamed(context, ForgotPassword.id);
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 90),
          socialSignIn(),
        ],
      ),
    );
  }

  Future<void> RegisterUser() async {
    RegistrationProvider _registrationProvider = RegistrationProvider();
    PopUpDialogs popUpDialogs = PopUpDialogs(context: context);
    popUpDialogs.showLoadingAnimation(
      context: context,
      message: "Processing",
    );
    var data = await _registrationProvider.LoginUser(
      number: userNameController.text,
      password: passwordController.text,
    );
    popUpDialogs.closeDialog();
    if (!data.hasException) {
      var response = data.data;
      bool responseVal = response!["tokenAuth"]["success"];
      if (responseVal) {
        toastMessage(context: context, message: "Registration Successful");
        _sharedPreferenceProvider.setString(
          key: "AccountType",
          value: isDriverSignUp ? "driver" : "ordinary",
        );
        Navigator.popAndPushNamed(context, DriverHomeInit.id);
      } else {
        toastMessage(
            context: context, message: "Error, Invalid credentials passed");
      }
    } else {
      toastMessage(
        context: context,
        message: "Error, ${data.exception.toString()}",
      );
    }
  }

  Column socialSignIn() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "or connect with ",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
        SizedBox(height: 35),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            signOptions(
              icon: Icon(FontAwesome.twitter, color: Colors.blue),
              function: () {},
            ),
            signOptions(
              icon: Icon(FontAwesome.facebook, color: Colors.blue),
              function: () {},
            ),
            signOptions(
              icon: Icon(FontAwesome.apple, color: Colors.black),
              function: () {},
            ),
            signOptions(
              icon: Image(
                image: AssetImage("assets/images/Google.png"),
                height: 25,
              ),
              function: () {},
            ),
          ],
        )
      ],
    );
  }

  registrationBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: TextStyle(fontSize: 15),
          ),
          InkWell(
            onTap: () {
              Navigator.popAndPushNamed(context, RegistrationActivity.id);
            },
            child: Text(
              "Sign Up",
              style: TextStyle(color: kPrimary, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
