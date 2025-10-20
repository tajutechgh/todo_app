import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/todo.dart';

class TodoService {

  static const String baseUrl = "http://10.0.2.2:8080/api/v1/todos";

  // GET all todos
  static Future<List<Todo>> fetchAllTodos() async {

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

      return body.map((e) => Todo.fromJson(e)).toList();

    } else {

      if (kDebugMode) {
        print('Failed to load all todos, code: ${response.statusCode}');
      }

      throw Exception('Failed to load all todos');
    }
  }

  // GET all completed todos
  static Future<List<Todo>> fetchAllCompletedTodos() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return [];

    final response = await http.get(

      Uri.parse('$baseUrl/completed'),

      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {

      List body = jsonDecode(response.body);

      return body.map((e) => Todo.fromJson(e)).toList();

    } else {

      if (kDebugMode) {
        print('Failed to load all completed todos, code: ${response.statusCode}');
      }

      throw Exception('Failed to load all completed todos');
    }
  }

  // GET all pending todos
  static Future<List<Todo>> fetchAllPendingTodos() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return [];

    final response = await http.get(

      Uri.parse('$baseUrl/pending'),

      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {

      List body = jsonDecode(response.body);

      return body.map((e) => Todo.fromJson(e)).toList();

    } else {

      if (kDebugMode) {
        print('Failed to load all pending todos, code: ${response.statusCode}');
      }

      throw Exception('Failed to load all pending todos');
    }
  }

  // POST create new todo
  static Future<Todo?> createTodo(Todo todo) async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return null;

    final response = await http.post(

      Uri.parse('$baseUrl/create'),

      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },

      body: jsonEncode(todo.toJson()),

    );

    if (response.statusCode == 201) {

      return Todo.fromJson(jsonDecode(response.body));

    } else {

      if (kDebugMode) {
        print('Failed to create todo, code: ${response.statusCode}');
      }

      throw Exception('Failed to create new todo');
    }
  }

  // PUT update todo
  static Future<Todo?> updateTodo(int id, Todo todo) async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return null;

    final response = await http.put(

      Uri.parse('$baseUrl/update/$id'),

      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },

      body: jsonEncode(todo.toJson()),

    );

    if (response.statusCode == 200) {

      return Todo.fromJson(jsonDecode(response.body));

    } else {

      if (kDebugMode) {
        print('Failed to update todo, code: ${response.statusCode}');
      }

      throw Exception('Failed to update todo');
    }
  }

  // DELETE todo
  static Future<void> deleteTodo(int id) async {

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
        print('Failed to delete todo, code: ${response.statusCode}');
      }

      throw Exception('Failed to delete todo');
    }
  }

  // PATCH check todo complete
  static Future<void> completeTodo(int id) async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return;

    final response = await http.patch(

      Uri.parse('$baseUrl/complete/$id'),

      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {

      if (kDebugMode) {
        print('Todo status updated successfully: ${response.body}');
      }

    } else {

      if (kDebugMode) {
        print('Failed to update todo status: ${response.statusCode} - ${response.body}');
      }
    }
  }

  // PATCH check todo pending
  static Future<void> pendingTodo(int id) async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return;

    final response = await http.patch(

      Uri.parse('$baseUrl/incomplete/$id'),

      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {

      if (kDebugMode) {
        print('Todo status updated successfully: ${response.body}');
      }

    } else {

      if (kDebugMode) {
        print('Failed to update todo status: ${response.statusCode} - ${response.body}');
      }
    }
  }
}
