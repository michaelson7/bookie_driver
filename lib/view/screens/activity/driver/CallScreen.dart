import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../../../provider/shared_prefrence_provider.dart';
import '../../../constants/enum.dart';
import 'message_screen.dart';

class CallScreen extends StatefulWidget {
  static String id = "CallScreen";
  const CallScreen({Key? key}) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

// Navigator.popAndPushNamed(context, LoginActivity.id);
class _HomeActivityState extends State<CallScreen> {
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFAD29DA),
                  Color(0xFFAD29DA),
                  Color(0xFFAD29DA),
                  Color(0xFFD348AE)
                ],
              ),
            ),
          ),
          SafeArea(child: buildContainer())
        ],
      ),
    );
  }

  buildContainer() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 50),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(365)),
              child: CachedNetworkImage(
                height: 150.0,
                width: 150.0,
                imageUrl:
                    "https://images.unsplash.com/photo-1553272725-086100aecf5e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHw2fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Incoming Call",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Sarah",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 150),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              callIcons(
                text: "Decline",
                iconData: Image.asset(
                  "assets/images/callend.png",
                  width: 30,
                  height: 30,
                ),
                color: Colors.red,
              ),
              callIcons(
                text: "Accept",
                iconData: Icon(
                  FontAwesome.phone,
                  color: Colors.white,
                  size: 30,
                ),
                color: Colors.green,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget callIcons({
    required text,
    required Widget iconData,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(
              Radius.circular(365),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: InkWell(
              onTap: () {
                Navigator.popAndPushNamed(context, MessageScreen.id);
              },
              child: iconData,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
