import 'package:flutter/material.dart';

const kTextStyleHint = TextStyle(color: Colors.grey);
const kTextStyleWhite = TextStyle(color: Colors.white);
const kTextStyleHeader1 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const kTextStyleHeader2 = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
const kCardBackground = Color(0xFFDBDBDB);
const kAccent = Color(0xFFA21FE5);
const kPrimary = Color(0xFF6A74CF);
const kImageRadius = BorderRadius.all(Radius.circular(8));
const kImageRadiusTop = BorderRadius.only(
  topRight: Radius.circular(8),
  topLeft: Radius.circular(8),
);
const kBorderRadiusCircular = BorderRadius.all(Radius.circular(10));
const kBorderRadiusCircularPro = BorderRadius.all(Radius.circular(60));
var kCardBorderRadius = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12.0),
);
var kButtonRounded = ButtonStyle(
  // backgroundColor:
  // MaterialStateProperty.all<Color>(Color(0xFFE4579A)),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ),
);
Color kCardBackgroundFaint = Color(0xca7a7a7);
