import 'package:bookie_driver/view/widgets/star_boy.dart';
import 'package:flutter/material.dart';

import 'logger_widget.dart';

Widget tripData({
  required String time,
  required String location,
  required String amount,
}) {
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
              "AM",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          paddedText(
            top: Text(
              location,
              style: TextStyle(color: Colors.white),
            ),
            bottom: StarRating(
              rating: 3,
              color: Colors.yellow,
              onRatingChanged: (rating) => loggerInfo(
                message: rating.toString(),
              ),
            ),
          ),
          paddedText(
            top: Text(
              "K${amount}",
              style: TextStyle(color: Colors.white),
            ),
            bottom: Text(
              "Card",
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

Column paddedText({
  required Widget top,
  required Widget bottom,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      top,
      SizedBox(height: 5),
      bottom,
    ],
  );
}
