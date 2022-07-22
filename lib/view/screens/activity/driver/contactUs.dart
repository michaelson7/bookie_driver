import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../model/core/contactModel.dart';
import '../../../../provider/ContactProvider.dart';
import '../../../../provider/shared_prefrence_provider.dart';
import '../../../constants/constants.dart';
import '../../../widgets/appBar.dart';

class ContactUs extends StatefulWidget {
  static String id = "ContactUs";
  const ContactUs({Key? key}) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

// Navigator.popAndPushNamed(context, LoginActivity.id);
class _HomeActivityState extends State<ContactUs> {
  bool isLoading = true;
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  ContactProvider contactProvider = ContactProvider();
  ContactModel? contactData;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    contactData = await contactProvider.getContact();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Contact Us",
        color: kAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: buildContainer(),
            ),
    );
  }

  buildContainer() {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: kAccent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(365)),
                        color: Colors.yellow,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          FontAwesome.phone,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "GET IN TOUCH!",
                    style: kTextStyleHeader2.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 30)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email:", style: TextStyle(color: kAccent)),
                Text(contactData!.contactDetails!.first.email),
                SizedBox(height: 10),
                Text("Phone:", style: TextStyle(color: kAccent)),
                Text(contactData!.contactDetails!.first.phone),
                SizedBox(height: 10),
                Text("Address:", style: TextStyle(color: kAccent)),
                Text(contactData!.contactDetails!.first.address),
                SizedBox(height: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
}
