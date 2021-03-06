import 'package:bookie_driver/view/constants/constants.dart';
import 'package:bookie_driver/view/screens/activity/driver/DriverHomeInit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import '../../../../provider/RegistrationProvider.dart';
import '../../../widgets/PopUpDialogs.dart';
import '../../../widgets/toast.dart';
import 'email_confirmation.dart';
import 'forgot_password.dart';
import 'login_activity.dart';

class PasswordReset extends StatefulWidget {
  static String id = "PasswordReset";
  String email;
  PasswordReset({Key? key, required this.email}) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState(email);
}

class _HomeActivityState extends State<PasswordReset> {
  String email;
  TextEditingController newPasswordController = TextEditingController(),
      confirmPasswordController = TextEditingController();
  String otpValueController = "";
  var _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _passwordVisible2 = false;
  int passwordLevel = 0;
  _HomeActivityState(this.email);

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
          otpValueController = pin;
        },
      ),
    );
  }

  passwordSection() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text("ENTER NEW PASSWORD"),
          SizedBox(height: 8),
          Material(
            borderRadius: kBorderRadiusCircularPro,
            color: Colors.grey[200],
            child: ListTile(
              leading: Icon(FontAwesome.lock, color: Colors.black),
              title: TextField(
                controller: newPasswordController,
                obscureText: !_passwordVisible,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Password',
                  hintText: 'Enter Password',
                  suffixIcon: IconButton(
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
                  ),
                ),
                onChanged: (value) {
                  RegExp regex = RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                  RegExp regex2 = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z]).{4,}$');
                  RegExp regex3 = RegExp(r'^.{2,}$');
                  if (regex.hasMatch(value)) {
                    setState(() {
                      passwordLevel = 3;
                    });
                  } else if (regex2.hasMatch(value)) {
                    setState(() {
                      passwordLevel = 2;
                    });
                  } else if (regex3.hasMatch(value)) {
                    setState(() {
                      passwordLevel = 1;
                    });
                  } else {
                    setState(() {
                      passwordLevel = 0;
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Text("CONFIRM NEW PASSWORD"),
          SizedBox(height: 10),
          Material(
            borderRadius: kBorderRadiusCircularPro,
            color: Colors.grey[200],
            child: ListTile(
              leading: Icon(FontAwesome.lock, color: Colors.black),
              title: TextField(
                obscureText: !_passwordVisible2,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Confirm Password',
                  hintText: 'Enter Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible2
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible2 = !_passwordVisible2;
                      });
                    },
                  ),
                ),
                controller: confirmPasswordController,
              ),
            ),
          ),
        ],
      ),
    );
  }

  passwordStregth() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: stepper(
              title: "Weak",
              color: passwordLevel >= 1 ? Color(0xFFFD749B) : Colors.white24,
            ),
          ),
          Expanded(
            child: stepper(
              title: "Average",
              color: passwordLevel >= 2 ? Color(0xFFFD749B) : Colors.white24,
            ),
          ),
          Expanded(
            child: stepper(
              title: "Strong",
              color: passwordLevel >= 3 ? Color(0xFFFD749B) : Colors.white24,
            ),
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
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          if (newPasswordController.text != confirmPasswordController.text) {
            toastMessage(
              context: context,
              message: "New password does not match confirmed password",
            );
          } else {
            var dialog = PopUpDialogs(context: context);
            var provider = RegistrationProvider();
            dialog.showLoadingAnimation(context: context);
            //
            var response = await provider.resetPasswords(
              email: email,
              otp: otpValueController,
              password1: newPasswordController.text,
              password2: confirmPasswordController.text,
            );
            dialog.closeDialog();
            if (response.resetPassword?.response == 200) {
              Navigator.popAndPushNamed(context, LoginActivity.id);
            }
          }
        } else {
          toastMessage(context: context, message: "Please Add Required Data");
        }
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
