import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/user.dart';

class AuthService {

  final storage = const FlutterSecureStorage();

  static const String baseUrl = "http://localhost:8080/api/v1/auth";

  static Future<bool> register(User user) async {

    final response = await http.post(

      Uri.parse('$baseUrl/register'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode(user.toRegisterJson()),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> login(User user) async {

    final response = await http.post(

      Uri.parse('$baseUrl/login'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode(user.toLoginJson()),
    );

    if (response.statusCode == 200) {

      final body = jsonDecode(response.body);

      // Correct key name
      final token = body['accessToken'];
      final tokenType = body['tokenType'] ?? 'Bearer';

      if (token == null) {

        if (kDebugMode) {
          print('No token found in response.');
        }

        return false;
      }

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('jwt_token', 'Bearer $token');
      await prefs.setString('token_type', tokenType);

      if (kDebugMode) {
        print('Token saved successfully!');;
      }

      return true;

    } else {

      if (kDebugMode) {
        print('Login failed: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      return false;
    }
  }

  static Future<String?> getToken() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('jwt_token');
  }

  static Future<String?> getCurrentUsername() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return null;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    return decodedToken['sub'];
  }

  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('role');
  }

  static Future<Map<String, dynamic>?> fetchUserProfile() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return null;

    final response = await http.get(

      Uri.parse('$baseUrl/current-user'),

      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return data;

    } else {

      if (kDebugMode) {
        print('Failed to load user profile: ${response.body}');
      }

      return null;
    }
  }

  static Future<void> logout() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('jwt_token');
  }
}
