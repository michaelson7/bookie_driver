import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

Widget signOptions({required Widget icon, required Function function}) {
  return InkWell(
    onTap: () => function,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.1, color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: icon,
      ),
    ),
  );
}
