import 'dart:math';
import 'package:bookie_driver/view/widgets/toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../provider/TripProvider.dart';
import '../../provider/shared_prefrence_provider.dart';
import '../../view/constants/enum.dart';
import '../../view/screens/activity/driver/DriverAcceptTrip.dart';
import '../../view/widgets/PopUpDialogs.dart';
import '../../view/widgets/logger_widget.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initialise(
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/launcher_icon"),
      iOS: IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? notification) async {
      //perform on click
      handleNotification(
        notification!,
        navigatorKey.currentState!.context,
      );
    });
  }

  Future<void> display(RemoteMessage message) async {
    try {
      final id = DateTime.now().microsecondsSinceEpoch ~/ 1000;
      var random = Random();
      var num = pow(2, 31);
      var total = num - 1;
      int id1 = random.nextInt(total.toInt());
      final NotificationDetails notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
          "DEFAULT_CHANNEL",
          "DEFAULT_CHANNEL channel",
          channelDescription: "default app channel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id1,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: message.data["src"],
      );
    } on Exception catch (e) {
      loggerError(message: "NOTIFICATION ERROR ${e}");
    }
  }

  Future<void> handleNotification(String notification, context) async {
    loggerInfo(message: notification.toString());
    switch (notification) {
      case "customer request":
        await openRequestTripList(context, notification);
        break;
    }
  }

  Future<void> openRequestTripList(
    context,
    String notification,
  ) async {
    PopUpDialogs dialogs = PopUpDialogs(context: context);
    dialogs.showLoadingAnimation(
      context: context,
      message: "Loading Trip Data",
    );
    TripProvider _provider = TripProvider();
    SharedPreferenceProvider _sp = SharedPreferenceProvider();
    bool? isOnlineTemp = await _sp.getBoolValue("isOnline");
    var data = await _provider.allTripRequests(jsonBody: {"": ""});
    var photo = await _sp.getStringValue(getEnumValue(UserDetails.userPhoto));
    dialogs.closeDialog();
    if (isOnlineTemp ?? false) {
      if (data.allRequestTrip!.length > 0) {
        await Future.delayed(Duration(seconds: 6));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DriverAcceptTrip(
              model: data,
              profilePhoto: photo ?? "",
            ),
          ),
        );
      }
    } else {
      toastMessage(
        context: context,
        message: "You must be online to receive trip requests",
      );
    }
  }
}
