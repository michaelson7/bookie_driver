import 'package:flutter/material.dart';

import '../constants/constants.dart';

CustomAppBar({
  required title,
  Color color = Colors.white,
  List<Widget>? action,
}) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
        fontSize: 20,
        color: color == Colors.white ? Colors.black : Colors.white,
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.black, //change your color here
    ),
    backgroundColor: color,
    actions: action,
  );
}
