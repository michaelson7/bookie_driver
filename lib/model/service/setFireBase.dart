import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../main.dart';
import 'NotificationService.dart';

LocalNotificationService service = LocalNotificationService();
Future<void> setFireBase() async {
  if (Platform.isIOS) {
    FirebaseMessaging.instance.requestPermission();
  }

  //config
  service.initialise(navigatorKey);

  //init when app is closed
  FirebaseMessaging.instance.getInitialMessage().then((message) async {
    if (message != null) {
      var routeFromMessage = message?.data;
      service.handleNotification(
        message!.data["src"],
        navigatorKey.currentState!.context,
      );
    }
  });

  //foreground work - when app is opened
  FirebaseMessaging.onMessage.listen((message) {
    // loggerAccent(message: "FIREBASE BODY: ${message.notification?.body}");
    // loggerAccent(message: "FIREBASE TITLE: ${message.notification?.title}");
    // loggerAccent(message: "FIREBASE ROUTE: ${message.data}");
    service.display(message);
  });

  //background -  only works when app is in background and open
  FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    var routeFromMessage = message.data;
  });
}
