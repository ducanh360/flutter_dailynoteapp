
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';


class NotifyHelper{
 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
initializeNotification() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('appicon');


final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
);

await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
}
 void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
        final String? payload = notificationResponse.payload;

    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
     Get.to(()=>Container());
  }
  displayNotification({required String title, required String body}) async {
    print("doing test");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'You change your theme',
      'You changed your theme back !',
      platformChannelSpecifics,
      payload: 'It could be anything you pass',
    );
  }

 


}