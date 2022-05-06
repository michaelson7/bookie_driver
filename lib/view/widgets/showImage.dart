import 'dart:io';
import 'package:flutter/material.dart';
import '../constants/constants.dart';

showImage({required File file, required context}) {
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
            child: Image.file(file),
          ),
        );
      });
}
