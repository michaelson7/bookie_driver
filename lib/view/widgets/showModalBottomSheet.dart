import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../constants/constants.dart';

openBottomSheet({
  required context,
  required Function galleryFunction,
  required Function captureFunction,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: Container(
                color: kPrimary,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Upload Option",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Container(
                color: kAccent,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          galleryFunction();
                        },
                        child: Column(
                          children: [
                            Icon(
                              FontAwesome.picture_o,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Select Image\nFrom Gallary",
                              style: kTextStyleWhite.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 35,
                        color: kAccent,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          captureFunction();
                        },
                        child: Column(
                          children: [
                            Icon(
                              FontAwesome.camera,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Capture",
                              style: kTextStyleWhite.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
