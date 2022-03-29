import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../../../../provider/RegistrationProvider.dart';
import '../../../../provider/shared_prefrence_provider.dart';
import '../../../constants/constants.dart';
import '../../../constants/enum.dart';
import '../../../constants/mutations.dart';
import '../../../widgets/PopUpDialogs.dart';
import '../../../widgets/logger_widget.dart';
import '../../../widgets/toast.dart';
import 'driverPasswordReset.dart';
import 'driver_picture.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DriverOTP extends StatefulWidget {
  static String id = "DriverOTP";
  String idPro = "DriverOTP";
  String phoneNumber, password;
  bool isDriver;
  DriverOTP({
    Key? key,
    required this.phoneNumber,
    required this.password,
    this.isDriver = false,
  }) : super(key: key);

  @override
  _HomeActivityState createState() =>
      _HomeActivityState(phoneNumber, isDriver, password);
}

// Navigator.popAndPushNamed(context, LoginActivity.id);
class _HomeActivityState extends State<DriverOTP> {
  String phoneNumber, password;
  bool isDriver;
  PopUpDialogs? dialogs;
  OtpFieldController _otpFieldController = OtpFieldController();
  _HomeActivityState(this.phoneNumber, this.isDriver, this.password);

  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: buildContainer()));
  }

  buildContainer() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Text(
              "Phone Verification",
              style: kTextStyleHeader1,
            ),
            Text(
              "Please enter the 4-digit code sent to you at $phoneNumber",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Text("Resend Codes"),
            SizedBox(height: 40),
            Mutation(
              options: MutationOptions(
                document: gql(verifyPhoneNumber),
                update: (GraphQLDataProxy cache, QueryResult? result) {
                  return cache;
                },
                onCompleted: (dynamic resultData) async {
                  Map responseValue = jsonDecode(jsonEncode(resultData));
                  loggerAccent(message: "JSON RESPONSE: ${responseValue}");
                  var response = responseValue["verifyPhoneNumber"];
                  if (response["response"] == 200) {
                    var token = await generateToken();
                    var responseBody = token.data;
                    var response = responseBody!["tokenAuth"];
                    var tokenGenResponse = response["success"];

                    //check if login == true
                    if (tokenGenResponse) {
                      SharedPreferenceProvider sp = SharedPreferenceProvider();
                      if (isDriver) {
                        await sp.setString(
                          key: "AccountType",
                          value: "driver",
                        );
                        await registerAsDriver();
                      } else {
                        dialogs!.closeDialog();
                        toastMessage(
                          context: context,
                          message: "Registration Successful",
                        );
                        // Navigator.popAndPushNamed(context, Prefrences.id);
                      }
                    } else {
                      dialogs!.closeDialog();
                      toastMessage(
                        context: context,
                        message: "Error while generating token",
                      );
                    }
                  } else {
                    dialogs!.closeDialog();
                    _otpFieldController.clear();
                    toastMessage(
                      context: context,
                      message: "Error, Incorrect OTP",
                    );
                  }
                },
              ),
              builder: (
                RunMutation runMutation,
                QueryResult? result,
              ) {
                return OTPTextField(
                  controller: _otpFieldController,
                  length: 4,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 60,
                  style: TextStyle(fontSize: 15),
                  otpFieldStyle: OtpFieldStyle(backgroundColor: Colors.white),
                  fieldStyle: FieldStyle.box,
                  onCompleted: (pin) {
                    var jsonBody = {
                      "otp": pin,
                      "phoneNumber": phoneNumber,
                    };
                    toastMessage(context: context, message: "Uploading Data");
                    loggerAccent(message: "JSON BODY: $jsonBody");
                    dialogs = PopUpDialogs(context: context);
                    dialogs!.showLoadingAnimation(context: context);
                    runMutation(jsonBody);
                  },
                );
              },
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

  Future<dynamic> registerAsDriver() async {
    RegistrationProvider provider = RegistrationProvider();
    var data = await provider.getUserId();

    if (!data.hasException) {
      var responseBody = data.data;
      var response = responseBody!["me"];
      var userID = response["pk"];

      //register driver
      var jsonBody = {"user": "$userID", "nrcNumber": "4", "skills": "1"};
      var driverRegistration = await provider.CreateDriver(
        jsonBody: jsonBody,
      );

      //driver response
      if (!driverRegistration.hasException) {
        var responseBody = driverRegistration.data;
        var response = responseBody!["createDriver"];
        if (response!["response"] == 200) {
          dialogs!.closeDialog();
          toastMessage(
            context: context,
            message: "Driver Registration Successful",
          );
          Navigator.popAndPushNamed(context, DriverPicture.id);
        } else {
          dialogs!.closeDialog();
          toastMessage(
            context: context,
            message: "Error, ${response["message"]}",
          );
        }
      } else {
        dialogs!.closeDialog();
        toastMessage(
          context: context,
          message: "Error, ${data.exception.toString()}",
        );
      }
    } else {
      dialogs!.closeDialog();
      toastMessage(
        context: context,
        message: "Error, ${data.exception.toString()}",
      );
    }
  }

  Future<QueryResult> generateToken() async {
    RegistrationProvider provider = RegistrationProvider();
    var data = await provider.LoginUser(
      number: phoneNumber,
      password: password,
    );
    return data;
  }
}
