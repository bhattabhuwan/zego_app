import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://10.0.2.2:5000';
  final http.Client client = http.Client();

  // ========== REGISTER ==========
  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    try {
      final res = await client.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'email': email, 'password': password}),
      );

      print('REGISTER RESPONSE: ${res.statusCode} ${res.body}');
      if (res.statusCode == 200 || res.statusCode == 201) {
        return {'success': true, 'message': 'Registration successful'};
      } else {
        final body = jsonDecode(res.body);
        return {'success': false, 'message': body['msg'] ?? 'Registration failed'};
      }
    } catch (e) {
      print("REGISTER ERROR: $e");
      return {'success': false, 'message': e.toString()};
    }
  }

  // ========== LOGIN ==========
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await client.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('LOGIN RESPONSE: ${res.statusCode} ${res.body}');

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        await _storage.write(key: 'access_token', value: body['access_token']);
        await _storage.write(key: 'refresh_token', value: body['refresh_token']);
        return {'success': true, 'message': 'Login successful'};
      } else {
        final body = jsonDecode(res.body);
        return {'success': false, 'message': body['msg'] ?? 'Login failed'};
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
      return {'success': false, 'message': e.toString()};
    }
  }

  // ========== GET PROFILE ==========
  Future<Map<String, dynamic>?> getProfile() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) return null;

    try {
      final res = await client.get(
        Uri.parse('$baseUrl/protected'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('PROFILE RESPONSE: ${res.statusCode} ${res.body}');

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else if (res.statusCode == 401) {
        final refreshed = await refreshToken();
        if (refreshed) {
          return await getProfile();
        }
      }
      return null;
    } catch (e) {
      print("PROFILE ERROR: $e");
      return null;
    }
  }

  // ========== REFRESH TOKEN ==========
  Future<bool> refreshToken() async {
    final refresh = await _storage.read(key: 'refresh_token');
    if (refresh == null) {
      print("NO REFRESH TOKEN FOUND");
      return false;
    }

    try {
      final res = await client.post(
        Uri.parse('$baseUrl/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refresh',
        },
      );

      print('REFRESH RESPONSE: ${res.statusCode} ${res.body}');

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        await _storage.write(key: 'access_token', value: body['access_token']);
        return true;
      }
      return false;
    } catch (e) {
      print("REFRESH ERROR: $e");
      return false;
    }
  }

  // ========== LOGOUT ==========
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  // ========== DELETE ACCOUNT ==========
  Future<Map<String, dynamic>> deleteAccount() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) return {'success': false, 'message': 'No token found'};

    try {
      final res = await client.delete(
        Uri.parse('$baseUrl/delete-account'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('DELETE RESPONSE: ${res.statusCode} ${res.body}');

      if (res.statusCode == 200) {
        await logout();
        return {'success': true, 'message': 'Account deleted successfully'};
      }
      return {'success': false, 'message': 'Failed to delete account'};
    } catch (e) {
      print("DELETE ERROR: $e");
      return {'success': false, 'message': e.toString()};
    }
  }

  // ========== FORGOT PASSWORD ==========
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final res = await client.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      print('FORGOT PASSWORD RESPONSE: ${res.statusCode} ${res.body}');

      if (res.statusCode == 200) {
        return {'success': true, 'message': 'Password reset email sent'};
      } else {
        final body = jsonDecode(res.body);
        return {'success': false, 'message': body['msg'] ?? 'Failed to send reset email'};
      }
    } catch (e) {
      print("FORGOT PASSWORD ERROR: $e");
      return {'success': false, 'message': e.toString()};
    }
  }

  // ========== RESET PASSWORD WITH TOKEN ==========
  Future<Map<String, dynamic>> resetPassword(String token, String newPassword) async {
    try {
      final res = await client.post(
        Uri.parse('$baseUrl/reset-password/$token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'new_password': newPassword}),
      );

      print('RESET PASSWORD RESPONSE: ${res.statusCode} ${res.body}');

      if (res.statusCode == 200) {
        return {'success': true, 'message': 'Password reset successful'};
      } else {
        final body = jsonDecode(res.body);
        return {'success': false, 'message': body['msg'] ?? 'Password reset failed'};
      }
    } catch (e) {
      print("RESET PASSWORD ERROR: $e");
      return {'success': false, 'message': e.toString()};
    }
  }

  // ========== RESET PASSWORD FOR LOGGED-IN USER ==========
  Future<Map<String, dynamic>> loginWithOldPasswordAndReset(
      String oldPassword, String newPassword) async {
    try {
      final profile = await getProfile();
      if (profile == null) return {'success': false, 'message': 'Not logged in'};

      final email = profile['email'];

      // Verify old password
      final loginRes = await login(email, oldPassword);
      if (!loginRes['success']) {
        return {'success': false, 'message': 'Current password is incorrect'};
      }

      // Reset password for logged-in user
      final token = await _storage.read(key: 'access_token');
      if (token == null) return {'success': false, 'message': 'No access token'};

      final res = await client.post(
        Uri.parse('$baseUrl/reset-password-loggedin'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'new_password': newPassword}),
      );

      print('RESET LOGGED-IN PASSWORD RESPONSE: ${res.statusCode} ${res.body}');

      if (res.statusCode == 200) {
        return {'success': true, 'message': 'Password updated successfully'};
      } else {
        final body = jsonDecode(res.body);
        return {'success': false, 'message': body['msg'] ?? 'Failed to update password'};
      }
    } catch (e) {
      print('RESET PASSWORD ERROR: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
