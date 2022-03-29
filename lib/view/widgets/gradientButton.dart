import 'package:flutter/material.dart';

SizedBox gradientButton({
  Function? function,
  required title,
}) {
  return SizedBox(
    width: 300,
    child: function != null
        ? InkWell(
            onTap: () => function(),
            child: childBody(title),
          )
        : childBody(title),
  );
}

Container childBody(title) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(60)),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF6A74CF),
          Color(0xFFF18BE7),
        ],
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}
