// import 'dart:convert';
// import 'dart:io';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
//
// import 'constant.dart';
// import 'Session.dart';
// import 'string.dart';
//
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
// FirebaseMessaging messaging = FirebaseMessaging.instance;
//
// class PushNotificationService {
//   final BuildContext? context;
//   final Function? updateHome;
//
//   PushNotificationService({this.context, this.updateHome});
//
//   Future initialise() async {
//     iOSPermission();
//     messaging.getToken().then((token) async {
//       CUR_USERID = await getPrefrence(ID);
//       if (CUR_USERID != null && CUR_USERID != "") _registerToken(token);
//     });
//
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('ic_launcher');
//     final IOSInitializationSettings initializationSettingsIOS =
//     IOSInitializationSettings();
//     final MacOSInitializationSettings initializationSettingsMacOS =
//     MacOSInitializationSettings();
//     final InitializationSettings initializationSettings =
//     InitializationSettings(
//         android: initializationSettingsAndroid,
//         iOS: initializationSettingsIOS,
//         macOS: initializationSettingsMacOS);
//
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       var data = message.notification!;
//
//       var title = data.title.toString();
//       var body = data.body.toString();
//       var image = message.data['image'] ?? '';
//       var type ='';
//       type=message.data['type'] ?? '';
//
//       if (image != null && image != 'null' && image != '') {
//         generateImageNotication(title, body, image, type);
//       } else {
//         generateSimpleNotication(title, body, type);
//       }
//     });
//   }
//
//   void iOSPermission() async {
//     await messaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//   void _registerToken(String? token) async {
//     var parameter = {USER_ID: CUR_USERID, FCM_ID: token};
//
//     Response response =
//     await post(updateFcmApi, body: parameter, headers: headers)
//         .timeout(Duration(seconds: timeOut));
//
//     var getdata = json.decode(response.body);
//   }
//
//
//   static Future<String> _downloadAndSaveImage(
//       String url, String fileName) async {
//     var directory = await getApplicationDocumentsDirectory();
//     var filePath = '${directory.path}/$fileName';
//     var response = await http.get(Uri.parse(url));
//
//
//     var file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     return filePath;
//   }
//   static Future<void> generateImageNotication(
//       String title, String msg, String image,String type) async {
//
//
//
//     var largeIconPath = await _downloadAndSaveImage(image, 'largeIcon');
//     var bigPicturePath = await _downloadAndSaveImage(image, 'bigPicture');
//     var bigPictureStyleInformation = BigPictureStyleInformation(
//         FilePathAndroidBitmap(bigPicturePath),
//         hideExpandedLargeIcon: true,
//         contentTitle: title,
//         htmlFormatContentTitle: true,
//         summaryText: msg,
//         htmlFormatSummaryText: true);
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'big text channel id',
//         'big text channel name',
//         channelDescription: 'big text channel description',
//         largeIcon: FilePathAndroidBitmap(largeIconPath),
//         styleInformation: bigPictureStyleInformation);
//     var platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//         0, title, msg, platformChannelSpecifics,payload: type);
//   }
//
//   static Future<void> generateSimpleNotication(String title, String msg,String type) async {
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'your channel id',
//         'your channel name',
//         channelDescription: 'your channel description',
//         importance: Importance.max, priority: Priority.high, ticker: 'ticker');
//     // channelDescription
//     var platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin
//         .show(0, title, msg, platformChannelSpecifics, payload:type );
//   }
// }
//
// Future<dynamic> myForgroundMessageHandler(RemoteMessage message) async {
//
//   return Future<void>.value();
// }

import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'constant.dart';
import 'Session.dart';
import 'string.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
FirebaseMessaging messaging = FirebaseMessaging.instance;

class PushNotificationService {
  final BuildContext? context;
  final Function? updateHome;
  ValueChanged onResult;
  PushNotificationService({this.context, this.updateHome, required this.onResult});

  Future initialise() async {
    iOSPermission();
    messaging.getToken().then((token) async {
      CUR_USERID = await getPrefrence(ID);
      if (CUR_USERID != null && CUR_USERID != "") _registerToken(token);
    });

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings();
    final MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      var data = message.notification!;
      var title = data.title.toString();
      var body = data.body.toString();
      var image = message.data['image'] ?? '';
      var type ='';
      type=message.data['type'] ?? '';
      if (image != null && image != 'null' && image != '') {
        generateImageNotication(title, body, image, type);
        onResult!("success");
      } else {
        generateSimpleNotication(title, body, type);
        onResult!("success");
      }
    });
  }

  void iOSPermission() async {
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _registerToken(String? token) async {
    var parameter = {USER_ID: CUR_USERID, FCM_ID: token};
    Response response =
    await post(updateFcmApi, body: parameter, headers: headers)
        .timeout(Duration(seconds: timeOut));
    //var getdata = json.decode(response.body);
  }

  static Future<String> _downloadAndSaveImage(
      String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(Uri.parse(url));
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
  static Future<void> generateImageNotication(
      String title, String msg, String image,String type) async {
    var largeIconPath = await _downloadAndSaveImage(image, 'largeIcon');
    var bigPicturePath = await _downloadAndSaveImage(image, 'bigPicture');
    var bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        hideExpandedLargeIcon: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: msg,
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        channelDescription: 'big text channel description',
        sound: RawResourceAndroidNotificationSound('test'),
        playSound: true,
        enableVibration: true,
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, msg, platformChannelSpecifics,payload: type);
  }

  static Future<void> generateSimpleNotication(String title, String msg,String type) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'default_notification_channel', 'High Importance Notifications',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500,
        sound: RawResourceAndroidNotificationSound('test'),
        ticker: 'ticker');
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, msg, platformChannelSpecifics, payload:type);
  }
}

Future<void> createSimpleNotication(
    String title, String msg, String type, String id, var data1) async {
  print(data1);
/*  List<NotificationActionButton> buttons = [];
  if(data1!=null){
    for(var v =0;v<data1.length;v++){
      Map data = jsonDecode(data1[0]);
      buttons.add(NotificationActionButton(key: data['key'], label: data['label'],buttonType: ActionButtonType.Default));
    }
  }*/

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'high_importance_channel',
      title: title,
      body: msg,
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
          key: "Reject", label: "Reject",),
      NotificationActionButton(
          key: "Accept", label: "Accept",)
    ],
  );
}


Future<dynamic> myForgroundMessageHandler(RemoteMessage message) async {
  return Future<void>.value();
}

