import 'package:bookie_driver/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

navigator({
  required String Startlat,
  required String Startlong,
  required String Endlat,
  required String Endlong,
  required context,
}) {
  launchMap(lat, long) async {
    var mapSchema = Uri.parse("google.navigation:q=$lat,$long&mode=d");
    if (await canLaunch(mapSchema.toString())) {
      await launch(mapSchema.toString());
    } else {
      toastMessage(context: context, message: 'Could not launch $mapSchema');
    }
  }

  return Row(
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: () async {
            await launchMap(Startlat, Startlong);
          },
          child: Text(
            "Navigate to\nPick Up Point",
            textAlign: TextAlign.center,
          ),
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        child: ElevatedButton(
          onPressed: () async {
            await launchMap(Endlat, Endlong);
          },
          child: Text(
            "Navigate to\nDestination Point",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  );
}
