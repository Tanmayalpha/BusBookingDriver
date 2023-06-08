// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:deliveryboy_multivendor/Helper/string.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:qcabs_driver/Auth/Login/UI/login_page.dart';
// import 'package:qcabs_driver/DrawerPages/Home/offline_page.dart';
// import 'package:qcabs_driver/utils/ApiBaseHelper.dart';
// import 'package:qcabs_driver/utils/common.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../main.dart';
//
// import 'Common.dart';
// import 'Session.dart';
// import 'constant.dart';
//
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
// FirebaseMessaging messaging = FirebaseMessaging.instance;
//
// Future<void> backgroundMessage(RemoteMessage message) async {
//
//   /* var data = message.notification!;
//   var title = data.title.toString();
//   var body = data.body.toString();
//   var test = message.data;
//   print(test['Booking_id']);
//   generateImageNotication(title, body, image, test['Booking_id'], test['Booking_id']);*/
//   /*await Firebase.initializeApp();
//
//   print("Handling a background message: ${message.messageId}");
//
//   // Use this method to automatically convert the push data, in case you gonna use our data standard
//   AwesomeNotifications().createNotificationFromJsonData(message.data);
//   Map<String, dynamic> notificationAdapter = {
//     NOTIFICATION_CHANNEL_KEY: 'high_importance_channel',
//     NOTIFICATION_ID: message.messageId,
//     NOTIFICATION_TITLE: message.notification!.title.toString(),
//     NOTIFICATION_BODY: message.notification!.body.toString() ,
//     NOTIFICATION_LAYOUT:'Default',
//     NOTIFICATION_BUTTONS:[
//       NotificationActionButton(key: "Reject", label: "Reject",buttonType: ActionButtonType.Default),
//       NotificationActionButton(key: "Accept", label: "Accept",buttonType: ActionButtonType.Default)
//     ],
//   };
//   AwesomeNotifications().createNotificationFromJsonData(notificationAdapter);
//   print(message.notification?.title);*/
// }
//
// class PushNotificationService {
//   BuildContext context;
//   ValueChanged onResult;
//   PushNotificationService({required this.context,required this.onResult});
//
//   Future initialise() async {
//     await App.init();
//     iOSPermission();
//     messaging.getToken().then((token) async {
//       // FCM_ID = token;
//       onResult("yes");
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
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (String? payload) async {
//           Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => OfflinePage(payload.toString())),
//                   (route) => false);
//         });
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       App.localStorage.setBool("notStatus", true);
//       notificationStatus = App.localStorage.getBool("notStatus")!;
//       print("0k" + message.toString());
//       var data = message.notification!;
//       var title = data.title.toString();
//       var body = data.body.toString();
//       var test = message.data;
//       print(test['Booking_id']);
//       bookingId = test['Booking_id'];
//       if(title.toString().contains("update")){
//         onResult("update");
//       }else  if(title.toString().contains("cancelled")){
//         onResult("cancelled");
//       } else{
//         onResult(bookingId);
//       }
//       /* if(bookingId==""){
//         bookingId = test['Booking_id'];
//         print("okay");
//         onResult(bookingId);
//      */
//       /*   Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => OfflinePage(test['Booking_id'])),
//                 (route) => false);*/
//       /*
//       }else{
//         if(bookingId==test['Booking_id']){
//           print("no");
//         }else{
//           bookingId = test['Booking_id'];
//           onResult(bookingId);
//         }
//       }*/
//       print(test);
//       var image = message.data['image'] ?? '';
//       print(image);
//       var type = message.data['type'] ?? '';
//       var id = '';
//       id = message.data['type_id'] ?? '';
//       if (image != null && image != 'null' && image != '') {
//         // generateImageNotication(title, body, image, type, bookingId);
//       } else {
//         // generateSimpleNotication(title, body, type, bookingId);
//         // createSimpleNotication(title, body, type, id, test);
//       }
//     });
//
//     messaging.getInitialMessage().then((RemoteMessage? message) async {
//       await Future.delayed(Duration.zero);
//     });
//
//     FirebaseMessaging.onBackgroundMessage(backgroundMessage);
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       var test = message.data;
//       print(test);
//       /*  bookingId = test['Booking_id'];
//       onResult(bookingId);*/
//       //onResult(bookingId);
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
// }
//
// Future<dynamic> myForgroundMessageHandler(RemoteMessage message) async {
//   return Future<void>.value();
// }
//
// Future<String> _downloadAndSaveImage(String url, String fileName) async {
//   var directory = await getApplicationDocumentsDirectory();
//   var filePath = '${directory.path}/$fileName';
//   var response = await http.get(Uri.parse(url));
//
//   var file = File(filePath);
//   await file.writeAsBytes(response.bodyBytes);
//   return filePath;
// }
//
// Future<void> generateImageNotication(
//     String title, String msg, String image, String type, String id) async {
//   var largeIconPath = await _downloadAndSaveImage(image, 'largeIcon');
//   var bigPicturePath = await _downloadAndSaveImage(image, 'bigPicture');
//   var bigPictureStyleInformation = BigPictureStyleInformation(
//       FilePathAndroidBitmap(bigPicturePath),
//       hideExpandedLargeIcon: true,
//       contentTitle: title,
//       htmlFormatContentTitle: true,
//       summaryText: msg,
//       htmlFormatSummaryText: true);
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'high_importance_channel', 'big text channel name',
//       channelDescription: 'big text channel description',
//       sound: RawResourceAndroidNotificationSound('test'),
//       playSound: true,
//       enableVibration: true,
//       largeIcon: FilePathAndroidBitmap(largeIconPath),
//       styleInformation: bigPictureStyleInformation);
//   var platformChannelSpecifics =
//   NotificationDetails(android: androidPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin
//       .show(0, title, msg, platformChannelSpecifics, payload: id);
// }
//
// Future<void> generateSimpleNotication(
//     String title, String msg, String type, String id) async {
//   print("yehuyibaat");
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'default_notification_channel', 'High Importance Notifications',
//       channelDescription: 'your channel description',
//       importance: Importance.max,
//       priority: Priority.max,
//       playSound: true,
//       enableVibration: true,
//       enableLights: true,
//       color: const Color.fromARGB(255, 255, 0, 0),
//       ledColor: const Color.fromARGB(255, 255, 0, 0),
//       ledOnMs: 1000,
//       ledOffMs: 500,
//       sound: RawResourceAndroidNotificationSound('test'),
//       ticker: 'ticker');
//
//   var iosDetail = IOSNotificationDetails();
//
//   var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics, iOS: iosDetail);
//   await flutterLocalNotificationsPlugin
//       .show(0, title, msg, platformChannelSpecifics, payload: id);
// }
//
// Future<void> createSimpleNotication(
//     String title, String msg, String type, String id, var data1) async {
//   print(data1);
// /*  List<NotificationActionButton> buttons = [];
//   if(data1!=null){
//     for(var v =0;v<data1.length;v++){
//       Map data = jsonDecode(data1[0]);
//       buttons.add(NotificationActionButton(key: data['key'], label: data['label'],buttonType: ActionButtonType.Default));
//     }
//   }*/
//
//   await AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: 1,
//       channelKey: 'high_importance_channel',
//       title: title,
//       body: msg,
//       notificationLayout: NotificationLayout.Default,
//     ),
//     actionButtons: [
//       NotificationActionButton(
//           key: "Reject", label: "Reject", actionType: ActionType.Default),
//       NotificationActionButton(
//           key: "Accept", label: "Accept", actionType: ActionType.Default)
//     ],
//   );
// }
//
// ApiBaseHelper apiBaseHelper = new ApiBaseHelper();
// registerToken() async {
//   Map data = {
//     "user_id": CUR_USERID,
//     // "device_id": fcmToken,
//   };
//   Map response = await apiBaseHelper.postAPICall(
//       Uri.parse(baseUrl + "update_Fcm_token_driver"), data);
//   if (response['status']) {
//   } else {}
// }
