import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/todo.dart';

import 'base_url.dart';

class TodoService {

  // GET all todos
  static Future<List<Todo>> fetchAllTodos() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return [];

    final response = await http.get(

      Uri.parse(BaseUrl.getAllTodos),

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

      Uri.parse(BaseUrl.getAllCompletedTodos),

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

      Uri.parse(BaseUrl.getAllPendingTodos),

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

      Uri.parse(BaseUrl.createTodos),

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

      Uri.parse(BaseUrl.updateTodo(id)),

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

        Uri.parse(BaseUrl.deleteTodo(id)),

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

      Uri.parse(BaseUrl.updateTodosCompleteStatus(id)),

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

      Uri.parse(BaseUrl.updateTodosPendingStatus(id)),

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
