import 'package:bookie_driver/view/widgets/star_boy.dart';
import 'package:flutter/material.dart';

import 'logger_widget.dart';

Widget tripData({
  required String time,
  required String location,
  required String amount,
  double ratingVal = 0.0,
}) {
  var timeVal = int.parse(time.split(":")[0]);
  return Card(
    color: Colors.grey[900],
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          paddedText(
            top: Text(time, style: TextStyle(color: Colors.white)),
            bottom: Text(
              timeVal <= 12 ? "AM" : "PM",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: paddedText(
                top: Text(
                  location,
                  style: TextStyle(color: Colors.white),
                ),
                bottom: StarRating(
                  rating: ratingVal,
                  shouldCenter: true,
                  color: Colors.yellow,
                  onRatingChanged: (rating) => loggerInfo(
                    message: rating.toString(),
                  ),
                ),
              ),
            ),
          ),
          paddedText(
            top: Text(
              "K${amount}",
              style: TextStyle(color: Colors.white),
            ),
            bottom: Text(
              "",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget paddedText({
  required Widget top,
  required Widget bottom,
}) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        top,
        SizedBox(height: 5),
        bottom,
      ],
    ),
  );
}
