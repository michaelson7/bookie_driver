import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../../../../provider/RegistrationProvider.dart';
import '../../../constants/constants.dart';
import '../../../widgets/PopUpDialogs.dart';
import '../../../widgets/toast.dart';
import 'email_confirmation.dart';

class ForgotPassword extends StatefulWidget {
  static String id = "ForgotPassword";
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  var _formKey = GlobalKey<FormState>();

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
                fit: BoxFit.cover,
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
      child: SingleChildScrollView(
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
                    child: Center(
                        child: Image.asset("assets/images/ladylady.png")),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Divider(color: Colors.grey),
                        Material(
                          borderRadius: kBorderRadiusCircular,
                          color: Colors.grey[200],
                          child: ListTile(
                            leading: Icon(FontAwesome.phone),
                            title: TextFormField(
                              controller: emailController,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Phone Number',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 200),
            Center(
              child: Text(
                "Enter the phone number registered to be sent the OTP number",
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              child: InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    var dialog = PopUpDialogs(context: context);
                    var provider = RegistrationProvider();
                    dialog.showLoadingAnimation(context: context);
                    //
                    var response = await provider.forgotPasswords(
                        email: emailController.text);
                    dialog.closeDialog();
                    if (response.responseBody?.response == 200) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EmailConfirmation(email: emailController.text),
                        ),
                      );
                    } else {
                      toastMessage(
                        context: context,
                        message: response.responseBody?.message,
                      );
                    }
                  } else {
                    toastMessage(context: context, message: "Please Add Email");
                  }
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
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
