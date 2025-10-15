import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserService{
  static const String baseUrl = "http://10.0.2.2:8080/api/v1/auth/user";

  // get current user profile details
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
  
  // get current user data
  static Future<User> getCurrentUserData() async {
    
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.get(

      Uri.parse('$baseUrl/profile'),

      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return User.fromJson(data);

    } else {

      throw Exception('Failed to load user data: ${response.statusCode}');
    }
  }
  
  // update current user profile
  static Future<User?> updateCurrentUserProfile(int id, User user) async {
    
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return null;

    final response = await http.put(
      
      Uri.parse('$baseUrl/profile/update/$id'),

      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
      
      body: jsonEncode(user.toUserJson()),
    );

    if (response.statusCode == 200) {
      
      final data = jsonDecode(response.body);
      
      return User.fromJson(data); 
      
    } else {
      
      if (kDebugMode) {
        print('Failed to update user, code: ${response.statusCode}');
      }

      return null;
    }
  }
}