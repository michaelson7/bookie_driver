import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../../widgets/appBar.dart';
import 'addCard.dart';

class CreatePaymentMEthods extends StatefulWidget {
  static String id = "CreatePaymentMEthods";
  const CreatePaymentMEthods({Key? key}) : super(key: key);

  @override
  _CreatePaymentMEthodsState createState() => _CreatePaymentMEthodsState();
}

class _CreatePaymentMEthodsState extends State<CreatePaymentMEthods> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Payment Method",
      ),
      body: SafeArea(
        child: buildContainer(),
      ),
    );
  }

  Widget buildContainer() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 200,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AddCard.id);
                },
                child: Card(
                  elevation: 5,
                  color: Colors.grey[300],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        Text("Add Card"),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
