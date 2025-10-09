import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {

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

      final token = body['token'];

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('jwt_token', 'Bearer $token');

      return true;

    } else {

      return false;
    }
  }

  static Future<String?> getToken() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('jwt_token');
  }

  static Future<void> logout() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('jwt_token');
  }
}
