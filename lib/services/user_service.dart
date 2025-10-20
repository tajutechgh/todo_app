import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserService{
  static const String baseUrl = "http://10.0.2.2:8080/api/v1/users";

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

  // GET all users
  static Future<List<User>> fetchAllUsers() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return [];

    final response = await http.get(

      Uri.parse('$baseUrl/all'),

      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {

      List body = jsonDecode(response.body);

      return body.map((e) => User.fromJson(e)).toList();

    } else {

      if (kDebugMode) {
        print('Failed to load all users, code: ${response.statusCode}');
      }

      throw Exception('Failed to load all users');
    }
  }

  // POST create new user
  static Future<String> createUser(User user) async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return "token is null";

    final response = await http.post(

      Uri.parse('$baseUrl/create'),

      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },

      body: jsonEncode(user.toUserJson()),

    );

    if (response.statusCode == 201) {

      return "Success";

    } else {

      if (kDebugMode) {
        print('Failed to create user, code: ${response.statusCode}');
      }

      throw Exception('Failed to create new user');
    }
  }

  // PUT update user
  static Future<String> updateUser(int id, User user) async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return "token is null";

    final response = await http.put(

      Uri.parse('$baseUrl/update/$id'),

      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },

      body: jsonEncode(user.toUserJson()),

    );

    if (response.statusCode == 200) {

      return "Success";

    } else {

      if (kDebugMode) {
        print('Failed to update user, code: ${response.statusCode}');
      }

      throw Exception('Failed to update user');
    }
  }

  // DELETE user
  static Future<void> deleteUser(int id) async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return;

    final response = await http.delete(

      Uri.parse('$baseUrl/delete/$id'),

      headers: {
        'Authorization': token,
      },
    );

    if (response.statusCode != 200) {

      if (kDebugMode) {
        print('Failed to delete user, code: ${response.statusCode}');
      }

      throw Exception('Failed to delete todo');
    }
  }
}