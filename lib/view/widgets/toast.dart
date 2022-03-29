import 'package:flutter/material.dart';

void toastMessage({required BuildContext context, required message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
