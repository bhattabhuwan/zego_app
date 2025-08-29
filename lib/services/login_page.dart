// import 'package:flutter/material.dart';
// import 'package:zego_app/services/auth_service.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
// final _emailCtrl = TextEditingController();
// final _passCtrl =TextEditingController();

// final _auth = AuthService();
// bool _loading =false;
// String _msg='';


// void _doLogin() async{
//   setState(() {
//     _loading =true; _msg ='';
//   });

//   final ok =await _auth.login(_emailCtrl.text.trim(),
//   _passCtrl.text);
//   setState(() {
//     _msg
//   });

// }

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }

// }