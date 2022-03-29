import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../../../provider/shared_prefrence_provider.dart';
import '../../../constants/constants.dart';
import '../../../constants/enum.dart';

class MessageScreen extends StatefulWidget {
  static String id = "MessageScreen";
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

// Navigator.popAndPushNamed(context, LoginActivity.id);
class _HomeActivityState extends State<MessageScreen> {
  TextEditingController _messageController = TextEditingController();
  SharedPreferenceProvider _sp = SharedPreferenceProvider();

  var messageBodySender = [
    BubbleSpecialThree(
      text: 'Oii, are you nearby',
      color: Color(0xFFFFFFFF),
      tail: false,
      textStyle: TextStyle(fontSize: 16),
    ),
    BubbleSpecialThree(
      text: 'Hello?',
      color: Color(0xFFFFFFFF),
      tail: false,
      textStyle: TextStyle(fontSize: 16),
    ),
    BubbleSpecialThree(
      text: 'Hi',
      color: Color(0xFFE8E8EE),
      tail: false,
      isSender: false,
    ),
    BubbleSpecialThree(
      text: "Im arround the corner",
      color: Color(0xFFE8E8EE),
      tail: false,
      isSender: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBuild(),
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
      bottomNavigationBar: bottomContainer(),
    );
  }

  AppBar appBarBuild() {
    return AppBar(
      toolbarHeight: 100,
      backgroundColor: kAccent,
      centerTitle: true,
      title: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(365)),
            child: CachedNetworkImage(
              height: 70.0,
              width: 70.0,
              imageUrl:
                  "https://images.unsplash.com/photo-1553272725-086100aecf5e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHw2fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60",
              fit: BoxFit.cover,
            ),
          ),
          Text(
            "Lauren Chinkuli",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            CupertinoIcons.video_camera,
            color: Colors.blue,
            size: 50,
          ),
        )
      ],
    );
  }

  buildContainer() {
    return ListView.builder(
      // reverse: true,
      itemCount: messageBodySender.length,
      itemBuilder: (context, i) {
        return messageBodySender[i];
      },
    );
  }

  Container bottomContainer() {
    return Container(
      color: Color(0xFFD348AE),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              FontAwesome.camera,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: _messageController,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Message',
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              var message = BubbleSpecialThree(
                text: _messageController.text,
                color: Color(0xFFFFFFFF),
                tail: false,
                textStyle: TextStyle(fontSize: 16),
              );
              setState(() {
                messageBodySender.add(message);
                _messageController.text = "";
              });
            },
            icon: Icon(
              Icons.send,
            ),
          ),
        ],
      ),
    );
  }
}
