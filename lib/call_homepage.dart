// import 'package:flutter/material.dart';
// import 'package:zego_app/call_page.dart';


//  // Make sure you have this file for ZEGO call page

// class CallHomepage extends StatelessWidget {
//   final TextEditingController callIdController = TextEditingController();

//   CallHomepage({super.key});

//   void _joinCall(BuildContext context) {
//     String callId = callIdController.text.trim();
//     if (callId.isNotEmpty) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ZegoCallPage(roomId: callId),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a meeting ID')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Join Call",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             letterSpacing: 1.5,
//           ),
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'Enter Meeting ID',
//                 style: TextStyle(fontSize: 20),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: callIdController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Meeting ID',
//                 ),
//                 onSubmitted: (_) {
//                   // Optional: Navigate when user presses Enter
//                   _joinCall(context);
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => _joinCall(context),
//                 child: const Text('Start Call'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

