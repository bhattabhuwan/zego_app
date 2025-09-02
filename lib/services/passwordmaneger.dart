import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_page.dart';
import 'protected_page.dart';

class PasswordManager {
  final AuthService _auth = AuthService();

  /// Show forgot password dialog from LoginPage
  void showForgotPasswordDialog(BuildContext context) {
    final TextEditingController emailCtrl = TextEditingController();
    bool loading = false;
    String msg = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Forgot Password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                const SizedBox(height: 10),
                if (msg.isNotEmpty)
                  Text(
                    msg,
                    style: TextStyle(
                      color: msg.toLowerCase().contains("success") ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (loading) const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        setState(() {
                          loading = true;
                          msg = '';
                        });

                        final result = await _auth.forgotPassword(emailCtrl.text.trim());
                        setState(() {
                          loading = false;
                          msg = result['message'];
                        });
                      },
                child: const Text("Send"),
              ),
            ],
          );
        });
      },
    );
  }

  /// Show reset password dialog from ProtectedPage
  void showResetPasswordDialog(BuildContext context) {
    final TextEditingController tokenCtrl = TextEditingController();
    final TextEditingController passCtrl = TextEditingController();
    bool loading = false;
    String msg = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Reset Password"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tokenCtrl,
                    decoration: const InputDecoration(labelText: "Reset Token"),
                  ),
                  TextField(
                    controller: passCtrl,
                    decoration: const InputDecoration(labelText: "New Password"),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  if (msg.isNotEmpty)
                    Text(
                      msg,
                      style: TextStyle(
                        color: msg.toLowerCase().contains("success") ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (loading) const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        setState(() {
                          loading = true;
                          msg = '';
                        });

                        final result = await _auth.resetPassword(
                            tokenCtrl.text.trim(), passCtrl.text.trim());

                        setState(() {
                          loading = false;
                          msg = result['message'];
                        });

                        if (result['success']) {
                          // Navigate to login after success
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginPage()),
                                (route) => false);
                          });
                        }
                      },
                child: const Text("Reset"),
              ),
            ],
          );
        });
      },
    );
  }
}
