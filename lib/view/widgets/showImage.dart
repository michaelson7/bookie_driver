import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';

showImage({
  required File file,
  required context,
}) {
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

showNetworkImage({
  required image,
  required context,
}) {
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
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
            ),
          ),
        );
      });
}
