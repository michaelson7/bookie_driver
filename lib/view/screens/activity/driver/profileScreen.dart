import 'package:bookie_driver/view/screens/activity/driver/DriverHomeInit.dart';
import 'package:bookie_driver/view/screens/activity/driver/vechileDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../model/core/UserDataModel.dart';
import '../../../../provider/RegistrationProvider.dart';
import '../../../../provider/shared_prefrence_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../constants/constants.dart';
import '../../../constants/enum.dart';
import '../../../widgets/PopUpDialogs.dart';
import '../../../widgets/appBar.dart';
import '../../../widgets/gradientButton.dart';
import '../../../widgets/logger_widget.dart';
import '../../../widgets/toast.dart';

class ProfileScreen extends StatefulWidget {
  static String id = "ProfileScreen";
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<ProfileScreen> {
  bool selectedImage = false;
  File? Photo;
  String? base64Image;
  bool isLoading = true;
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  RegistrationProvider registrationProvider = RegistrationProvider();
  UserDataModel? userDataModel;
  var nameController = TextEditingController(),
      emailController = TextEditingController();
  var imagePath = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getDate();
  }

  Future<void> getDate() async {
    var data = await registrationProvider.getUserId();
    userDataModel = UserDataModel.fromJson(
      data.data!,
    );
    setState(() {
      nameController.text =
          "${userDataModel?.me?.firstName} ${userDataModel?.me?.lastName}";
      emailController.text = "${userDataModel?.me?.email}";
      try {
        imagePath = "${userDataModel?.me?.profilepictureSet?.first.image}";
      } catch (e) {}
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, DriverHomeInit.id);
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Profile",
          color: kAccent,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Stack(
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
              ProfilePhoto(),
              PersonalData(),
              SizedBox(height: 20),
              VechileData(),
              SizedBox(height: 20),
              submitBUtton(),
            ],
          ),
        ),
      ),
    );
  }

  Column ProfilePhoto() {
    return Column(
      children: [
        SizedBox(height: 25),
        Center(
          child: Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () async {
                  await imageSelection(useCamera: false);
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
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.circular(100),
              image: selectedImage
                  ? DecorationImage(
                      image: FileImage(Photo!),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                      ).image,
                    ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Update profile picture",
              style: kTextStyleWhite,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Column PersonalData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Personal Information",
          style: kTextStyleHeader2.copyWith(color: Colors.white),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: kBorderRadiusCircular),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                options(
                    hint: "Full Name",
                    hintPro: "please enter full name",
                    showIcon: false,
                    controller: nameController),
                options(
                  hint: "Email",
                  hintPro: "please add email address",
                  showIcon: false,
                  controller: emailController,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column VechileData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Vehicle Information",
              style: kTextStyleHeader2.copyWith(color: Colors.white),
            ),
            userDataModel!.me!.driverSet!.first.drivervehicleSet!.isEmpty
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, VechileDetails.id);
                    },
                    child: const Text("ADD VEHICLE"))
                : Container(),
          ],
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: kBorderRadiusCircular),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    vechileCarOptions(
                      title: "Reg Plate",
                      value: userDataModel!
                              .me!.driverSet!.first.drivervehicleSet!.isNotEmpty
                          ? "${userDataModel!.me!.driverSet!.first.drivervehicleSet!.first.registrationPlate}"
                          : "",
                    ),
                    divider(),
                    vechileCarOptions(
                      title: "Vehicle Model",
                      value: userDataModel!
                              .me!.driverSet!.first.drivervehicleSet!.isNotEmpty
                          ? "${userDataModel!.me!.driverSet!.first.drivervehicleSet!.first.modelName}"
                          : "",
                    ),
                    divider(),
                    vechileCarOptions(
                      title: "Vehicle Color",
                      value: userDataModel!
                              .me!.driverSet!.first.drivervehicleSet!.isNotEmpty
                          ? "${userDataModel!.me!.driverSet!.first.drivervehicleSet!.first.modelColor}"
                          : "",
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.grey,
                    height: 1,
                    width: double.infinity,
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: CachedNetworkImage(
                    height: 150.0,
                    width: double.infinity,
                    imageUrl: userDataModel!
                            .me!.driverSet!.first.drivervehicleSet!.isNotEmpty
                        ? "${userDataModel!.me!.driverSet!.first.drivervehicleSet!.first.image}"
                        : "",
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column vechileCarOptions({required title, required value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: kTextStyleWhite.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          "$value",
          style: kTextStyleWhite.copyWith(color: Colors.grey[200]),
        ),
      ],
    );
  }

  Widget submitBUtton() {
    return Container(
      width: double.infinity,
      child: gradientButton(
        function: () async {
          if (_formKey.currentState!.validate()) {
            bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
            ).hasMatch(emailController.text);
            if (emailValid) {
              submitData();
            } else {
              toastMessage(
                context: context,
                message: "Please enter valid email address",
              );
            }
          } else {
            toastMessage(context: context, message: "Please add required data");
          }
        },
        title: "Update",
      ),
    );
  }

  Future<void> submitData() async {
    //update user data
    var dialog = PopUpDialogs(context: context);
    dialog.showLoadingAnimation(context: context, message: "Uploading Data");
    //
    var userId = await _sp.getStringValue(getEnumValue(UserDetails.userId));
    await registrationProvider.updateAccountData(
      userId: userId,
      firstName: nameController.text.split(" ").length > 1
          ? nameController.text.split(" ")[0]
          : "",
      lastName: nameController.text.split(" ").length > 1
          ? nameController.text.split(" ")[1]
          : "",
      email: emailController.text.trim(),
    );
    //update shared prefrences
    await _sp.setString(
      key: getEnumValue(UserDetails.userName),
      value: nameController.text.split(" ").length > 1
          ? nameController.text.split(" ")[0] +
              " " +
              nameController.text.split(" ")[1]
          : "",
    );
    await _sp.setString(
      key: getEnumValue(UserDetails.userEmail),
      value: emailController.text,
    );
//
    if (selectedImage) {
      var photoName = '${DateTime.now().second}.jpg';
      var byteData = Photo?.readAsBytesSync();
      var multipartFile = http.MultipartFile.fromBytes(
        'photo',
        byteData!,
        filename: photoName,
        contentType: MediaType("image", "jpg"),
      );
      var provider = RegistrationProvider();
      var imageResponse = await provider.updateProfilePhoto(
        userId: userId,
        photo: multipartFile,
      );

      if (imageResponse.uploadProfilePicture!.success!) {
        await _sp.setString(
          key: getEnumValue(UserDetails.userPhoto),
          value: "https://bookie-media.s3.af-south-1.amazonaws.com/" +
              "${imageResponse.uploadProfilePicture?.profilePicture?.image}",
        );
      }
    }
    dialog.closeDialog();
    toastMessage(context: context, message: "Account Updated");
  }

  options({
    required hint,
    required hintPro,
    required controller,
    bool showIcon = false,
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
                      controller: controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: new InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.grey,
                        border: InputBorder.none,
                        hintText: hintPro,
                      ),
                    ),
                  ),
                ),
                showIcon
                    ? Padding(
                        padding: const EdgeInsets.all(12),
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

  Container divider() {
    return Container(
      color: Colors.grey,
      height: 20,
      width: 1,
    );
  }

  Future<void> imageSelection({required bool useCamera}) async {
    try {
      ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      final bytes = File(image!.path).readAsBytesSync();
      if (image != null) {
        setState(() {
          selectedImage = true;
          Photo = File(image.path);
          base64Image = base64Encode(bytes);
          loggerInfo(message: "$base64Image");
        });
      }
    } catch (e) {
      toastMessage(context: context, message: e.toString());
    }
  }
}
