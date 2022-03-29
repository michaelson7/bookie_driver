import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../../constants/constants.dart';
import '../../../widgets/appBar.dart';
import 'create_payment_method.dart';

class PaymentSelectionActivity extends StatefulWidget {
  static String id = "PaymentSelectionActivity";
  const PaymentSelectionActivity({Key? key}) : super(key: key);

  @override
  _PaymentSelectionActivityState createState() =>
      _PaymentSelectionActivityState();
}

class _PaymentSelectionActivityState extends State<PaymentSelectionActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Payment Method",
        // backgroundColor: kAccent,
        action: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, CreatePaymentMEthods.id);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(FontAwesome.plus),
            ),
          ),
        ],
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
            Row(
              children: [
                Icon(FontAwesome.credit_card_alt, size: 15),
                SizedBox(width: 10),
                Text("Cards"),
              ],
            ),
            cardsList(),
            SizedBox(height: 15),
            Row(
              children: [
                Icon(FontAwesome.phone, size: 15),
                SizedBox(width: 10),
                Text("Mobile Money"),
              ],
            ),
            MoMoList(),
            SizedBox(height: 15),
            Text(
              "OTHER PAYMENT",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            OtherPayment(),
          ],
        ),
      ),
    );
  }

  cardsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, i) {
        return InkWell(
          splashColor: kAccent,
          onTap: () {
            //TODO, pass payment option to previous screen
            Navigator.pop(context, 'Woodlands ${i}');
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                //   color: Colors.white70,
                borderRadius: BorderRadius.all(Radius.circular(3)),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: kBorderRadiusCircular),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://cdn-icons-png.flaticon.com/128/196/196578.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Master Card"),
                        Text(
                          "**** **** **** 4587",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  MoMoList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, i) {
        return InkWell(
          splashColor: kAccent,
          onTap: () {
            //TODO, pass payment option to previous screen
            Navigator.pop(context, 'Woodlands ${i}');
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                //   color: Colors.white70,
                borderRadius: BorderRadius.all(Radius.circular(3)),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: kBorderRadiusCircular),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://s3-ap-southeast-1.amazonaws.com/bsy/iportal/images/airtel-logo1.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Airtel Mobile Money"),
                        Text(
                          "+260 928 605 395",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  OtherPayment() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 1,
      itemBuilder: (context, i) {
        return InkWell(
          splashColor: kAccent,
          onTap: () {
            //TODO, pass payment option to previous screen
            Navigator.pop(context, 'Woodlands ${i}');
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                //   color: Colors.white70,
                borderRadius: BorderRadius.all(Radius.circular(3)),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: kBorderRadiusCircular),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        //cashOption.png
                        child: Image.asset(
                          "assets/images/cashOption.png",
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cash Payment",
                          style: TextStyle(
                              color: Color(0xFF282F62),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Default Payment",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
