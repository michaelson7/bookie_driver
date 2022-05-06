import 'dart:io';
import 'package:bookie_driver/view/screens/activity/driver/DriverHomeInit.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:bookie_driver/provider/RegistrationProvider.dart';
import 'package:bookie_driver/view/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../model/core/carTypeModel.dart';
import '../../../../provider/DriverProvider.dart';
import '../../../../provider/shared_prefrence_provider.dart';
import '../../../constants/enum.dart';
import '../../../widgets/PopUpDialogs.dart';
import '../../../widgets/gradientButton.dart';
import '../../../widgets/logger_widget.dart';
import '../../../widgets/showImage.dart';
import '../../../widgets/showModalBottomSheet.dart';
import '../../../widgets/toast.dart';
import 'BusinessRegistration.dart';
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
  bool selectedImage = false;
  bool isLoading = true;
  File? profileFile;
  CarTypeModel? model;
  String dropdownValue = "";
  List<String> momoList = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    var provider = DriverProvider();
    model = await provider.getCarTypes();

    setState(() {
      for (var data in model!.allVehicleClass!) {
        dropdownValue = "${data.id}";
        momoList.add(
          "${data.id},${data.name}",
        );
      }
      isLoading = false;
    });
  }

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
          SafeArea(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : buildContainer())
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
                superHint: "e.g Toyota",
                showIcon: false,
                controller: _brandController,
                errorMessage: "Enter Brand",
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Vehicle Type",
                      style: kTextStyleWhite,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                underline: SizedBox(),
                                icon: const Visibility(
                                  visible: false,
                                  child: Icon(
                                    Icons.arrow_downward,
                                  ),
                                ),
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                items: momoList.map((dataValue) {
                                  loggerInfo(message: dataValue.toString());
                                  var value = dataValue.split(",");
                                  return DropdownMenuItem(
                                    child: Text(value[1]),
                                    value: value[0],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              options(
                hint: "Model",
                superHint: "e.g Corolla",
                showIcon: false,
                controller: _modelController,
                errorMessage: "Enter Model",
              ),
              options(
                hint: "Year",
                superHint: "2001",
                showIcon: false,
                controller: _yearController,
                errorMessage: "Enter Year",
              ),
              options(
                hint: "Plate number",
                superHint: "e.g abp 2058",
                controller: _plateController,
                errorMessage: "Enter Plate",
              ),
              options(
                hint: "Colour",
                superHint: "e.g black",
                showIcon: false,
                controller: _colorController,
                errorMessage: "Enter Colour",
              ),
              const Text(
                "Vehicle Image",
                style: kTextStyleWhite,
              ),
              InkWell(
                onTap: () async {
                  openBottomSheet(
                      context: context,
                      galleryFunction: () async {
                        var image = await imageSelection(useCamera: true);
                        if (image != null) {
                          setState(() {
                            selectedImage = true;
                            profileFile = File(image.path);
                          });
                        }
                      },
                      captureFunction: () async {
                        var image = await imageSelection(useCamera: true);
                        if (image != null) {
                          setState(() {
                            selectedImage = true;
                            profileFile = File(image.path);
                          });
                        }
                      });
                },
                child: Row(
                  children: [
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
                    SizedBox(width: 20),
                    selectedImage
                        ? ElevatedButton(
                            onPressed: () {
                              showImage(
                                file: profileFile!,
                                context: context,
                              );
                            },
                            child: const Text("Preview"))
                        : const SizedBox()
                  ],
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
    required String superHint,
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
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: superHint,
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
    if (selectedImage) {
      if (_formKey.currentState!.validate()) {
        RegistrationProvider provider = RegistrationProvider();
        DriverProvider driverProvider = DriverProvider();
        PopUpDialogs dialogs = PopUpDialogs(context: context);
        dialogs.showLoadingAnimation(context: context);
        var driverId = await provider.getUserId();
        var response = driverId.data;

        var photoName = '${DateTime.now().second}.jpg';
        var byteData = profileFile?.readAsBytesSync();
        var multipartFile = http.MultipartFile.fromBytes(
          'photo',
          byteData!,
          filename: photoName,
          contentType: MediaType("image", "jpg"),
        );

        if (response!["me"] != null) {
          var id = response["me"]["driverSet"][0]["id"];
          var jsonBody = {
            "vehicleClass": dropdownValue,
            "driver": id,
            "modelName": _modelController.text,
            "modelColor": _colorController.text,
            "insuranceDate": "2022-01-02",
            "roadTaxDate": "2022-01-02",
            "registrationPlate": _plateController.text,
            "image": multipartFile,
          };
          loggerInfo(message: response.toString());
          var car = await driverProvider.createDriverCar(jsonBody: jsonBody);
          var carResponse = car.data!["addDriverVehicle"];

          dialogs.closeDialog();
          if (carResponse["response"] == 200) {
            SharedPreferenceProvider _sp = SharedPreferenceProvider();
            await _sp.setBool(key: "hasVehicle", value: true);
            Navigator.popAndPushNamed(
              context,
              DriverHomeInit.id,
            );
          } else {
            // dialogs.closeDialog();
            toastMessage(context: context, message: carResponse["message"]);
          }
        } else {
          dialogs.closeDialog();
        }
      }
    } else {
      toastMessage(context: context, message: "Please Select Vehicle Image");
    }
  }

  Future<XFile?> imageSelection({
    required bool useCamera,
  }) async {
    try {
      ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(
        source: useCamera ? ImageSource.camera : ImageSource.gallery,
      );
      return image;
    } catch (e) {
      toastMessage(context: context, message: e.toString());
    }
  }
}
