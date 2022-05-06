import 'dart:io';
import 'package:bookie_driver/model/core/SkillsModel.dart';
import 'package:bookie_driver/model/core/UploadPhotoResponse.dart';
import 'package:bookie_driver/model/core/driverResponseModel.dart';
import 'package:bookie_driver/model/core/forgotPasswordResponse.dart';
import 'package:bookie_driver/provider/SkillsProvider.dart';
import 'package:bookie_driver/view/screens/activity/driver/DriverHomeInit.dart';
import 'package:bookie_driver/view/screens/activity/driver/vechileDetails.dart';
import 'package:bookie_driver/view/widgets/PopUpDialogs.dart';
import 'package:bookie_driver/view/widgets/logger_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql/src/core/query_result.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../provider/RegistrationProvider.dart';
import '../../../../provider/shared_prefrence_provider.dart';
import '../../../constants/constants.dart';
import '../../../constants/enum.dart';
import '../../../widgets/gradientButton.dart';
import '../../../widgets/showImage.dart';
import '../../../widgets/showModalBottomSheet.dart';
import '../../../widgets/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class DriverPicture extends StatefulWidget {
  static String id = "DriverPicture";
  const DriverPicture({Key? key}) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

// Navigator.popAndPushNamed(context, LoginActivity.id);
class _HomeActivityState extends State<DriverPicture> {
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  bool selectedImage = false,
      selectedLicenceFront = false,
      selectedLicenseBack = false;
  TextEditingController nrcController = TextEditingController();
  File? profileFile, licenceFontFile, licenseBackFile;

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
        child: Column(
          children: [
            SizedBox(height: 50),
            Container(
              child: Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () async {
                    var image = await imageSelection(useCamera: false);
                    if (image != null) {
                      setState(() {
                        selectedImage = true;
                        profileFile = File(image.path);
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              height: MediaQuery.of(context).size.width - 220,
              width: MediaQuery.of(context).size.width - 220,
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(100),
                image: selectedImage
                    ? DecorationImage(
                        image: FileImage(profileFile!),
                        fit: BoxFit.cover,
                      )
                    : DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.asset(
                          "assets/images/1234.png",
                          fit: BoxFit.cover,
                        ).image,
                      ),
              ),
            ),
            Text(
              "Add profile picture",
              style: kTextStyleWhite,
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                openBottomSheet(
                    context: context,
                    galleryFunction: () async {
                      var image = await imageSelection(useCamera: false);
                      if (image != null) {
                        setState(() {
                          selectedLicenceFront = true;
                          licenceFontFile = File(image.path);
                        });
                      }
                    },
                    captureFunction: () async {
                      var image = await imageSelection(useCamera: true);
                      if (image != null) {
                        setState(() {
                          selectedLicenceFront = true;
                          licenceFontFile = File(image.path);
                        });
                      }
                    });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  options(
                    hint: "License ID",
                    hintPro: "Front",
                    showIcon: true,
                  ),
                  selectedLicenceFront
                      ? ElevatedButton(
                          onPressed: () {
                            showImage(
                              file: licenceFontFile!,
                              context: context,
                            );
                          },
                          child: const Text("Preview"))
                      : const SizedBox()
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                openBottomSheet(
                    context: context,
                    galleryFunction: () async {
                      var image = await imageSelection(useCamera: false);
                      if (image != null) {
                        setState(() {
                          selectedLicenseBack = true;
                          licenseBackFile = File(image.path);
                        });
                      }
                    },
                    captureFunction: () async {
                      var image = await imageSelection(useCamera: true);
                      if (image != null) {
                        setState(() {
                          selectedLicenseBack = true;
                          licenseBackFile = File(image.path);
                        });
                      }
                    });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  options(
                    hint: "License ID",
                    hintPro: "Back",
                    showIcon: true,
                  ),
                  selectedLicenseBack
                      ? ElevatedButton(
                          onPressed: () {
                            showImage(
                              file: licenseBackFile!,
                              context: context,
                            );
                          },
                          child: const Text("Preview"),
                        )
                      : const SizedBox()
                ],
              ),
            ),
            // options(
            //   hint: "NRC Number",
            //   hintPro: "NRC Number",
            //   controller: nrcController,
            // ),
            options(
              hint: "Address",
              hintPro: "Address",
              controller: nrcController,
              // controller: nrcController,
            ),
            SizedBox(height: 60),
            gradientButton(
              function: () {
                submitData();
              },
              title: "Create",
            ),
          ],
        ),
      ),
    );
  }

  options({
    required hint,
    required hintPro,
    bool showIcon = false,
    TextEditingController? controller,
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
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      controller: controller,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.grey,
                        border: InputBorder.none,
                        hintText: hintPro,
                      ),
                    ),
                  ),
                ),
                showIcon
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.camera_alt,
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
    var provider = RegistrationProvider();
    var skillProvider = SkillsProvider();
    if (!selectedImage) {
      toastMessage(context: context, message: "Please select profile photo");
    } else if (!selectedLicenceFront) {
      toastMessage(context: context, message: "Please select front license");
    } else if (!selectedLicenseBack) {
      toastMessage(context: context, message: "Please select back license");
    } else if (nrcController.text == "") {
      toastMessage(context: context, message: "Please enter Address");
    } else {
      //setImage
      var dialog = PopUpDialogs(context: context);
      dialog.showLoadingAnimation(context: context, message: "Uploading");
      var data = await provider.getUserId();
      var skills = await skillProvider.allSkillsRequest();
      var photoResponse = await setProfilePhoto(provider, data);
      if (photoResponse.uploadProfilePicture!.success!) {
        var driverResponse = await driverReg(data, skills, provider);
        dialog.closeDialog();
        loggerAccent(message: driverResponse.toJson().toString());
        if (driverResponse.createDriver!.response == 200) {
          Navigator.popAndPushNamed(context, DriverHomeInit.id);
        } else {
          toastMessage(
            context: context,
            message: "${driverResponse.createDriver?.message}",
          );
        }
      } else {
        dialog.closeDialog();
        toastMessage(
          context: context,
          message: "Error while uploading profile photo",
        );
      }
    }
  }

  Future<DriverResponseModel> driverReg(QueryResult<dynamic> data,
      SkillsModel skills, RegistrationProvider provider) async {
    var responseBody = data.data;
    var response = responseBody!["me"];
    var userID = response["pk"];
    var photoName = '${DateTime.now().second}.jpg';
    var byteData = licenceFontFile?.readAsBytesSync();
    var multipartFile = http.MultipartFile.fromBytes(
      'photo',
      byteData!,
      filename: photoName,
      contentType: MediaType("image", "jpg"),
    );
    var jsonBody = {
      "user": "$userID",
      "address": nrcController.text,
      "skills": skills.allSkills?.first.id,
      "license": multipartFile,
    };
    var driverRegistration = await provider.CreateDriver(
      jsonBody: jsonBody,
    );
    return driverRegistration;
  }

  Future<UploadPhotoResponse> setProfilePhoto(
      RegistrationProvider provider, QueryResult<dynamic> data) async {
    var data = await provider.getUserId();
    var responseBody = data.data;
    var response = responseBody!["me"];
    var userID = response["pk"];
    var photoName = '${DateTime.now().second}.jpg';
    var byteData = profileFile?.readAsBytesSync();
    var multipartFile = http.MultipartFile.fromBytes(
      'photo',
      byteData!,
      filename: photoName,
      contentType: MediaType("image", "jpg"),
    );
    var imageResponse = await provider.updateProfilePhoto(
      userId: userID,
      photo: multipartFile,
    );
    if (imageResponse.uploadProfilePicture!.success!) {
      await _sp.setString(
        key: getEnumValue(UserDetails.userPhoto),
        value: "https://bookie-media.s3.af-south-1.amazonaws.com/" +
            "${imageResponse.uploadProfilePicture?.profilePicture?.image}",
      );
    }
    return imageResponse;
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
