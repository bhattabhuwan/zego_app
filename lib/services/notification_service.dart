// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin plugin =
//       FlutterLocalNotificationsPlugin();

//   // Global navigator key for notifications
//   static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//   static Future<void> initialize() async {
//     const AndroidInitializationSettings androidInit =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initSettings =
//         InitializationSettings(android: androidInit);

//     await plugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (details) {
//         final payload = details.payload;
//         if (payload != null) {
//           navigatorKey.currentState?.pushNamed("/call", arguments: payload);
//         }
//       },
//     );
//   }

//   static Future<void> showIncomingCallNotification(Map<String, dynamic> data) async {
//     final callerName = data['callerName'] ?? "Unknown";
//     final roomId = data['roomId'] ?? "default_room";

//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'incoming_call_channel',
//       'Incoming Call',
//       channelDescription: 'Incoming call notifications',
//       importance: Importance.max,
//       priority: Priority.max,
//       fullScreenIntent: true,
//       category: AndroidNotificationCategory.call,
//       playSound: true,
//       enableVibration: true,
//     );

//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidDetails);

//     await plugin.show(
//       0,
//       'Incoming Call',
//       'Call from $callerName',
//       notificationDetails,
//       payload: roomId,
//     );
//   }
// }
