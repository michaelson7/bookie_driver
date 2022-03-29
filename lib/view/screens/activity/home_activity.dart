import 'package:flutter/material.dart';

class HomeActivity extends StatefulWidget {
  static String id = "HomeActivity";
  const HomeActivity({Key? key}) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookie App"),
      ),
      body: SafeArea(
        child: buildContainer(),
      ),
    );
  }

  Container buildContainer() {
    return Container(
      child: Text("Hello World"),
    );
  }
}
