import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  Future<void> initZego() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await ZegoUIKitPrebuiltCallInvitationService().init(
        appID: 903242293,
        appSign:
            'fbf2b2e56424e1d986c781b2d2197af189ccc58ff4733694a63e2d05f75061fa',
        userID: user.uid,
        userName: user.email ?? 'User',
        plugins: [ZegoUIKitSignalingPlugin()],
        ringtoneConfig: ZegoRingtoneConfig(
          incomingCallPath: "assets/ringtone/incoming_call.mp3",
          outgoingCallPath: "assets/ringtone/outgoing_call.mp3",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // initialize Zego for logged-in user
      initZego();
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
