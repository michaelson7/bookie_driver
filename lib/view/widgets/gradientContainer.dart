import 'package:flutter/material.dart';

import '../constants/constants.dart';

gradientContainer({
  required Widget child,
  double? width,
  BorderRadius borderRadius = kBorderRadiusCircular,
}) {
  return Container(
    width: width,
    decoration: BoxDecoration(
      borderRadius: borderRadius,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF9D1BEA),
          Color(0xFFDE51A0),
        ],
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: child,
    ),
  );
}
