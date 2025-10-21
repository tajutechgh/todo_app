import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:todo_app/endpoints/base_url.dart';
import '../models/user.dart';

class AuthService {

  final storage = const FlutterSecureStorage();

  // register user
  static Future<bool> register(User user) async {

    final response = await http.post(

      Uri.parse(BaseUrl.register),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode(user.toRegisterJson()),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // login user
  static Future<bool> login(User user) async {

    final response = await http.post(

      Uri.parse(BaseUrl.login),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode(user.toLoginJson()),
    );

    if (response.statusCode == 200) {

      final body = jsonDecode(response.body);

      // Correct key name
      final token = body['accessToken'];
      final tokenType = body['tokenType'] ?? 'Bearer';
      final role = body['role'];

      if (token == null) {

        if (kDebugMode) {
          print('No token found in response.');
        }

        return false;
      }

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('jwt_token', 'Bearer $token');
      await prefs.setString('token_type', tokenType);
      await prefs.setString('role', role);

      if (kDebugMode) {
        print('Token saved successfully!');
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

  // get jwt token
  static Future<String?> getToken() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('jwt_token');
  }

  // get current user name
  static Future<String?> getCurrentUsername() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return null;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    return decodedToken['sub'];
  }

  // get current user role
  static Future<String?> getUserRole() async {
    
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('role');
  }

  // logout of your account
  static Future<void> logout() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('jwt_token');
  }
}
