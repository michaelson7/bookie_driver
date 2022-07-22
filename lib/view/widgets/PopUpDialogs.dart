import 'package:flutter/material.dart';

import '../constants/constants.dart';

class PopUpDialogs {
  BuildContext context;
  PopUpDialogs({required this.context});

  showLoadingAnimation({
    String message = "Processing",
    required BuildContext context,
  }) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (builder) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Image.asset("assets/images/505.gif", height: 120.0),
        );
      },
    );
  }

  closeDialog() {
    try {
      Navigator.pop(context);
    } catch (e) {}
  }
}
