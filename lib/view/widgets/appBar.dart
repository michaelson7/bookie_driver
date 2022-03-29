import 'package:flutter/material.dart';

import '../constants/constants.dart';

CustomAppBar({
  required title,
  Color color = kAccent,
  List<Widget>? action,
}) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.black, //change your color here
    ),
    backgroundColor: Colors.white,
    actions: action,
  );
}
