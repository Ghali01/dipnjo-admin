import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math' show Random;

class NotificationTypes {
  static const notifiction = '2';
  static const newOrder = '3';
}

Future<void> initNoitification() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('donuts');
  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (_) {});
}

Future<void> handleNotification(RemoteMessage message) async {
  FlutterLocalNotificationsPlugin().show(
      Random().nextInt(1000000),
      message.notification!.title,
      message.notification!.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "foods-1",
          'foods',
          importance: Importance.max,
        ),
      ));
}
