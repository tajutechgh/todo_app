import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService{
  static const String baseUrl = "http://10.0.2.2:8080/api/v1/auth/user";

  static Future<Map<String, dynamic>?> fetchUserProfile() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return null;

    final response = await http.get(

      Uri.parse('$baseUrl/profile'),

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
}