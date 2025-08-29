// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;

// class AuthService {
//   final _storage = const FlutterSecureStorage();
//   final String baseUrl = 'http://192.168.1.71:5000';

//   // Register with username, email, password
//   Future<bool> register(String username, String email, String password) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/register'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'username': username, 'email': email, 'password': password}),
//     );
//     return res.statusCode == 201;
//   }

//   // Login
//   Future<bool> login(String email, String password) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/login'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'email': email, 'password': password}),
//     );

//     if (res.statusCode == 200) {
//       final body = jsonDecode(res.body);
//       await _storage.write(key: 'access_token', value: body['access_token']);
//       await _storage.write(key: 'refresh_token', value: body['refresh_token']);
//       return true;
//     }
//     return false;
//   }

//   // Get protected profile
//   Future<Map<String, dynamic>?> getProfile() async {
//     final token = await _storage.read(key: 'access_token');
//     if (token == null) return null;

//     final res = await http.get(
//       Uri.parse('$baseUrl/protected'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (res.statusCode == 200) {
//       return jsonDecode(res.body);
//     } else if (res.statusCode == 401) {
//       final ok = await refreshToken();
//       if (ok) return getProfile();
//     }
//     return null;
//   }

//   // Refresh access token
//   Future<bool> refreshToken() async {
//     final refresh = await _storage.read(key: 'refresh_token');
//     if (refresh == null) return false;

//     final res = await http.post(
//       Uri.parse('$baseUrl/refresh'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $refresh',
//       },
//     );

//     if (res.statusCode == 200) {
//       final body = jsonDecode(res.body);
//       await _storage.write(key: 'access_token', value: body['access_token']);
//       return true;
//     }
//     return false;
//   }

//   // Logout
//   Future<void> logout() async {
//     await _storage.deleteAll();
//   }
// }
