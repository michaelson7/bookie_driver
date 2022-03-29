import 'package:flutter/material.dart';

Widget RoundedContainer(
    {Color color = Colors.white,
    required Widget child,
    double borderRadius = 12,
    double padding = 8.0}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      color: color,
    ),
    child: Padding(
      padding: EdgeInsets.all(padding),
      child: child,
    ),
  );
}
