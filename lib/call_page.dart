// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class ZegoCallPage extends StatefulWidget {
//   final String roomId;
//   final bool isVideoCall;

//   const ZegoCallPage({super.key, required this.roomId, required this.isVideoCall});

//   @override
//   State<ZegoCallPage> createState() => _ZegoCallPageState();
// }

// class _ZegoCallPageState extends State<ZegoCallPage> {
//   Timer? _callTimer;

//   @override
//   void initState() {
//     super.initState();

//     _callTimer = Timer(const Duration(minutes: 20), () {
//       if (mounted) {
//         Navigator.of(context).pop();
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Call ended after 20 minutes')));
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _callTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userId = FirebaseAuth.instance.currentUser?.uid ?? "tempUser";
//     final userName = FirebaseAuth.instance.currentUser?.email ?? "User";

//     final config = widget.isVideoCall
//         ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//         : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

//     return SafeArea(
//       child: ZegoUIKitPrebuiltCall(
//         appID: 903242293,
//         appSign:
//             'fbf2b2e56424e1d986c781b2d2197af189ccc58ff4733694a63e2d05f75061fa',
//         userID: userId,
//         userName: userName,
//         callID: widget.roomId,
//         config: config,
//       ),
//     );
//   }
// }
