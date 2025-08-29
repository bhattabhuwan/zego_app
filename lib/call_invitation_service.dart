import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallInvitationService {
  static const int appID = 903242293;
  static const String appSign =
      "fbf2b2e56424e1d986c781b2d2197af189ccc58ff4733694a63e2d05f75061fa";

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init({
    required String userId,
    required String userName,
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    // Set global navigator key
    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

    // Initialize local notifications
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);
    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // Initialize Zego call invitation
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: appID,
      appSign: appSign,
      userID: userId,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
      ringtoneConfig: ZegoRingtoneConfig(
        incomingCallPath: "assets/ringtone/incoming_call.mp3",
        outgoingCallPath: "assets/ringtone/outgoing_call.mp3",
      ),
    );

    // Event handler with correct signature
    ZegoUIKitPrebuiltCallInvitationEvents().onIncomingCallReceived =
        (String callID, ZegoCallUser inviter, ZegoCallInvitationType type,
         List<ZegoCallUser> invitees, String customData) {
      _showIncomingCallNotification(inviter.name);
    };
  }

  static Future<void> _showIncomingCallNotification(String callerName) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'incoming_call_channel',
      'Incoming Call',
      channelDescription: 'Notifications for incoming calls',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Incoming Call',
      'Call from $callerName',
      notificationDetails,
    );
  }

  static Future<void> cancelAllNotifications() async {}
}
