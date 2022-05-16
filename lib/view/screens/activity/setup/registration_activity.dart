import 'package:bookie_driver/provider/MutationProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../model/core/UserModel.dart';
import '../../../../provider/RegistrationProvider.dart';
import '../../../constants/constants.dart';
import '../../../constants/mutations.dart';
import '../../../widgets/PopUpDialogs.dart';
import '../../../widgets/gradientButton.dart';
import '../../../widgets/logger_widget.dart';
import '../../../widgets/signOptionsPro.dart';
import '../../../widgets/toast.dart';
import '../driver/driverOTP.dart';
import 'login_activity.dart';

class RegistrationActivity extends StatefulWidget {
  static String id = "RegistrationActivity";
  const RegistrationActivity({Key? key}) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<RegistrationActivity> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController(),
      _fullNameController = TextEditingController(),
      _passwordController = TextEditingController(),
      _phoneNumber = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Group 10.png"),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
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
            SizedBox(height: 90),
            // socialSignIn(),
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
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Image.asset("assets/images/logo.png", height: 80.0),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              materialTextField(
                controller: _fullNameController,
                icon: FontAwesome.user,
                hintText: "Full Name",
                errorMessage: "Please enter full names",
              ),
              Divider(color: Colors.grey),
              materialTextField(
                icon: Icons.email,
                controller: _emailController,
                hintText: "Email Address",
                errorMessage: "",
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
                icon: FontAwesome.lock,
                hintText: "Password",
                controller: _passwordController,
                obscureText: true,
                errorMessage: "Please enter Password",
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
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

  registrationBody() {
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
              Navigator.popAndPushNamed(context, LoginActivity.id);
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
                if (value == null || value.isEmpty && errorMessage != "") {
                  return errorMessage;
                }
                return null;
              },
              controller: controller,
              onChanged: (value) {
                setState(() {});
              },
              obscureText: obscureText ? !_passwordVisible : false,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                suffixIcon: obscureText
                    ? IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      )
                    : Text(""),
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

  Widget registrationButton() {
    return MutationProviderPro(
      response: (responseBody) {
        try {
          var response = responseBody["createAccount"];
          if (response["response"] == 200) {
            toastMessage(context: context, message: "Registration Successful");
            Navigator.pushNamed(
              context,
              DriverOTP(
                phoneNumber: _phoneNumber.text,
                password: _passwordController.text,
                isDriver: true,
              ).idPro,
            );
          } else {
            toastMessage(
              context: context,
              message: "Error, ${response["message"]}",
            );
          }
        } catch (e) {
          loggerError(message: e.toString());
          toastMessage(context: context, message: e.toString());
        }
      },
      mutation: createAccount,
      jsonBody: {
        "email": _emailController.text.trim(),
        "phoneNumber": _phoneNumber.text.trim(),
        "firstName": _fullNameController.text.split(" ").length > 1
            ? _fullNameController.text.split(" ")[0]
            : "",
        "lastName": _fullNameController.text.split(" ").length > 1
            ? _fullNameController.text.split(" ")[1]
            : "",
        "password": _passwordController.text.trim(),
      },
      formKey: _formKey,
      context: context,
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
              "Sign Up",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> RegisterUser() async {
    if (_formKey.currentState!.validate()) {
      RegistrationProvider _registrationProvider = RegistrationProvider();
      PopUpDialogs popUpDialogs = PopUpDialogs(context: context);
      popUpDialogs.showLoadingAnimation(
        context: context,
        message: "Processing",
      );
      UserModel model = UserModel(
        id: "5",
        photo: "",
        email: _emailController.text.trim(),
        phoneNumber: _phoneNumber.text.trim(),
        firstName: _fullNameController.text.split(" ").length > 1
            ? _fullNameController.text.split(" ")[0]
            : "",
        lastName: _fullNameController.text.split(" ").length > 1
            ? _fullNameController.text.split(" ")[1]
            : "",
        password: _passwordController.text.trim(),
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
    } else {
      toastMessage(context: context, message: "Please add required data");
    }
  }
}
