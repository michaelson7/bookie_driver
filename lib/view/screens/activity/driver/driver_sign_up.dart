import 'package:bookie_driver/model/core/UserModel.dart';
import 'package:bookie_driver/provider/MutationProvider.dart';
import 'package:bookie_driver/provider/RegistrationProvider.dart';
import 'package:bookie_driver/provider/shared_prefrence_provider.dart';
import 'package:bookie_driver/view/constants/constants.dart';
import 'package:bookie_driver/view/constants/mutations.dart';
import 'package:bookie_driver/view/screens/activity/setup/login_activity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../widgets/PopUpDialogs.dart';
import '../../../widgets/gradientButton.dart';
import '../../../widgets/signOptionsPro.dart';
import '../../../widgets/toast.dart';
import 'accountDetails.dart';
import 'driverOTP.dart';

class DriverSignUp extends StatefulWidget {
  static String id = "DriverSignUp";
  const DriverSignUp({Key? key}) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<DriverSignUp> {
  final _formKey = GlobalKey<FormState>();
  RegistrationProvider _registrationProvider = RegistrationProvider();
  TextEditingController _emailController = TextEditingController(),
      _fullNameController = TextEditingController(),
      _passwordController = TextEditingController(),
      _phoneNumber = TextEditingController();

  @override
  void initState() {
    _emailController.text = "lisa@email.com";
    _fullNameController.text = "lisa simone";
    _passwordController.text = "Password123!";
    _phoneNumber.text = "0954512435";
    super.initState();
  }

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
          buildContainer(),
        ],
      ),
    );
  }

  Widget buildContainer() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            loginBody(),
            SizedBox(height: 120),
            socialSignIn(),
            registrationBody(),
          ],
        ),
      ),
    );
  }

  Widget loginBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        Image.asset("assets/images/userHead.png", height: 120.0),
        Form(
          key: _formKey,
          child: Column(
            children: [
              materialTextField(
                  controller: _fullNameController,
                  icon: FontAwesome.user,
                  hintText: "Full Name",
                  errorMessage: "Please enter full names"),
              Divider(color: Colors.grey),
              materialTextField(
                icon: Icons.email,
                controller: _emailController,
                hintText: "Email Address",
                errorMessage: "Please enter Email",
              ),
              Divider(color: Colors.grey),
              materialTextField(
                icon: FontAwesome.phone,
                controller: _phoneNumber,
                hintText: "PhoneNumber",
                errorMessage: "Please enter PhoneNumber",
              ),
              Divider(color: Colors.grey),
              materialTextField(
                icon: FontAwesome.eye,
                hintText: "Password",
                controller: _passwordController,
                obscureText: true,
                errorMessage: "Please enter Password",
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
        SizedBox(
          width: 300,
          child: gradientButton(
            function: () async {
              await RegisterUser();
            },
            title: "Create",
          ),
        ),
      ],
    );
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

  Widget registrationBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account? ",
            style: TextStyle(fontSize: 15),
          ),
          InkWell(
            onTap: () {
              // registerAsDriver();
            },
            child: Text(
              "Login",
              style: TextStyle(color: kAccent),
            ),
          ),
        ],
      ),
    );
  }

  //FUNCTIONS
  Future<void> RegisterUser() async {
    PopUpDialogs popUpDialogs = PopUpDialogs(context: context);
    popUpDialogs.showLoadingAnimation(
      context: context,
      message: "Processing",
    );
    UserModel model = UserModel(
      id: "5",
      email: _emailController.text,
      phoneNumber: _phoneNumber.text,
      firstName: _fullNameController.text.split(" ").length > 1
          ? _fullNameController.text.split(" ")[0]
          : "",
      lastName: _fullNameController.text.split(" ").length > 1
          ? _fullNameController.text.split(" ")[1]
          : "",
      password: _passwordController.text,
    );
    var data = await _registrationProvider.RegisterUser(model: model);
    popUpDialogs.closeDialog();
    if (!data.hasException) {
      var responseBody = data.data;
      var response = responseBody!["createAccount"];
      if (response!["response"] == 200) {
        //save to sp

        toastMessage(context: context, message: "Registration Successful");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DriverOTP(
              phoneNumber: _phoneNumber.text,
              password: _passwordController.text,
              isDriver: true,
            ),
          ),
        );
      } else {
        toastMessage(
          context: context,
          message: "Error, ${response["message"]}",
        );
      }
    } else {
      toastMessage(
        context: context,
        message: "Error, ${data.exception.toString()}",
      );
    }
  }

  //WIDGETS
  Material materialTextField({
    required IconData icon,
    required hintText,
    required errorMessage,
    bool obscureText = false,
    required TextEditingController controller,
  }) {
    return Material(
      borderRadius: kBorderRadiusCircular,
      color: Colors.grey[200],
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(icon, color: Colors.black),
          ),
          Expanded(
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return errorMessage;
                }
                return null;
              },
              controller: controller,
              onChanged: (value) {
                setState(() {});
              },
              obscureText: obscureText,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
              ),
            ),
          )
        ],
      ),
    );
  }

  ListTile listTile505(IconData icon, hintText) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: TextField(
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }
}
