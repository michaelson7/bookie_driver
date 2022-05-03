import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/constants.dart';

openSMSorCallDialog({required context, required phoneNumber}) {
  var width = MediaQuery.of(context).size.width;
  showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kAccent,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Container(
            width: width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 120,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kAccent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(365)),
                          color: Colors.yellow,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.phone_in_talk,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: kBorderRadiusCircular,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text(
                          'Driver Contact',
                          style: kTextStyleHeader2,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Select option to either call or text driver",
                          style: kTextStyleHint,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  launchSMS(url: "${phoneNumber}");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: kBorderRadiusCircularPro,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "SMS",
                                      textAlign: TextAlign.center,
                                      style: kTextStyleWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  launchURL(url: "${phoneNumber}");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kAccent,
                                    borderRadius: kBorderRadiusCircularPro,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "CALL",
                                      textAlign: TextAlign.center,
                                      style: kTextStyleWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

void launchURL({required url}) async {
  if (!await launch("tel://$url")) throw 'Could not launch $url';
}

void launchSMS({required url}) async {
  if (!await launch("sms:$url")) throw 'Could not launch $url';
}
