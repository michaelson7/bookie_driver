import 'package:flutter/material.dart';

import '../constants/constants.dart';

Container dragContainerBody({required child}) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: kBorderRadiusCircular.copyWith(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        color: Colors.white),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 7,
            width: 45,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: kBorderRadiusCircularPro,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        child,
      ],
    ),
  );
}
