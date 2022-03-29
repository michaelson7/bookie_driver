import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../../constants/constants.dart';
import '../../../widgets/appBar.dart';
import '../../../widgets/gradientButton.dart';

class AddCard extends StatefulWidget {
  static String id = "AddCard";
  const AddCard({Key? key}) : super(key: key);

  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  TextEditingController cardNumberCOntroller = TextEditingController(),
      cardHolder = TextEditingController(),
      cardExpires = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cardNumberCOntroller.text = "4585 2889 5256 2548";
    cardHolder.text = "jane Doe";
    cardExpires.text = "11/22";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Card",
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            cardBody(),
            SizedBox(height: 20),
            cardDetails(),
            SizedBox(height: 60),
            SubmitButton()
          ],
        ),
      ),
    );
  }

  SizedBox cardBody() {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: InkWell(
        onTap: () {},
        child: Card(
          elevation: 5,
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/masterBoi.png",
                  height: 40.0,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  cardNumberCOntroller.text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    cardStyle(
                      leading: "Card Holder",
                      controller: cardHolder,
                    ),
                    SizedBox(width: 55),
                    cardStyle(
                      leading: "Expires",
                      controller: cardExpires,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cardDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: cardNumberCOntroller,
          decoration: new InputDecoration(
            hintText: 'Card Number',
          ),
        ),
        TextField(
          controller: cardHolder,
          decoration: new InputDecoration(
            hintText: 'Card Holder',
          ),
        ),
        TextField(
          controller: cardExpires,
          decoration: new InputDecoration(
            hintText: 'Expiray Date',
          ),
        ),
        TextField(
          decoration: new InputDecoration(
            hintText: 'CVV',
          ),
        ),
      ],
    );
  }

  Widget SubmitButton() {
    return gradientButton(
      function: () {},
      title: "Save",
    );
  }

  Column cardStyle({
    required leading,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(leading, style: kTextStyleHint),
        SizedBox(width: 100),
        Text(controller.text),
      ],
    );
  }
}
