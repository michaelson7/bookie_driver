import 'package:bookie_driver/provider/RegistrationProvider.dart';
import 'package:bookie_driver/view/constants/constants.dart';
import 'package:flutter/material.dart';

import '../../../../provider/DriverProvider.dart';
import '../../../../provider/shared_prefrence_provider.dart';
import '../../../constants/enum.dart';
import '../../../widgets/PopUpDialogs.dart';
import '../../../widgets/gradientButton.dart';
import '../../../widgets/logger_widget.dart';
import '../../../widgets/toast.dart';
import 'accountDetails.dart';
import 'driverOTP.dart';

class VechileDetails extends StatefulWidget {
  static String id = "VechileDetails";
  const VechileDetails({Key? key}) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

// Navigator.popAndPushNamed(context, LoginActivity.id);
class _HomeActivityState extends State<VechileDetails> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _brandController = TextEditingController(),
      _modelController = TextEditingController(),
      _yearController = TextEditingController(),
      _plateController = TextEditingController(),
      _colorController = TextEditingController();

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Vehicle Details",
                  style: kTextStyleWhite.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              options(
                hint: "Vehicle Brand",
                showIcon: true,
                controller: _brandController,
                errorMessage: "Enter Brand",
              ),
              options(
                hint: "Model",
                showIcon: true,
                controller: _modelController,
                errorMessage: "Enter Model",
              ),
              options(
                hint: "Year",
                showIcon: true,
                controller: _yearController,
                errorMessage: "Enter Year",
              ),
              options(
                hint: "Plate number",
                controller: _plateController,
                errorMessage: "Enter Plate",
              ),
              options(
                hint: "Colour",
                showIcon: true,
                controller: _colorController,
                errorMessage: "Enter Colour",
              ),
              Text(
                "Vehicle Image",
                style: kTextStyleWhite,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: kBorderRadiusCircular,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/images/addImage.png",
                    height: 40.0,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: gradientButton(
                      function: () {
                        submitData();
                      },
                      title: "SAVE",
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  options({
    required hint,
    bool showIcon = false,
    required controller,
    required errorMessage,
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
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return errorMessage;
                        }
                        return null;
                      },
                      decoration: new InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.grey,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                showIcon
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.keyboard_arrow_down,
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

  Future<void> submitData() async {
    // Navigator.popAndPushNamed(
    //   context,
    //   DriverAccountDetails.id,
    // );
    if (_formKey.currentState!.validate()) {
      RegistrationProvider provider = RegistrationProvider();
      DriverProvider driverProvider = DriverProvider();
      PopUpDialogs dialogs = PopUpDialogs(context: context);
      dialogs.showLoadingAnimation(context: context);
      var driverId = await provider.getUserId();
      var response = driverId.data;

      if (response!["me"] != null) {
        var id = response["me"]["driverSet"][0]["id"];
        var jsonBody = {
          "vehicleClass": "1",
          "driver": id,
          "modelName": _modelController.text,
          "modelColor": _colorController.text,
          "insuranceDate": "2022-01-02",
          "roadTaxDate": "2022-01-02",
          "registrationPlate": _plateController.text,
        };
        loggerInfo(message: response.toString());
        var car = await driverProvider.createDriverCar(jsonBody: jsonBody);
        var carResponse = car.data!["addDriverVehicle"];

        dialogs.closeDialog();
        if (carResponse["response"] == 200) {
          Navigator.popAndPushNamed(
            context,
            DriverAccountDetails.id,
          );
        } else {
          // dialogs.closeDialog();
          toastMessage(context: context, message: carResponse["message"]);
        }
      } else {
        dialogs.closeDialog();
      }
    }
  }
}
