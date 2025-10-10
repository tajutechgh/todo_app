import 'dart:ffi';

class Todo {

  final String title;
  final String description;
  final bool completed;
  final int userId;

  Todo({
    required this.title,
    required this.description,
    required this.completed,
    required this.userId
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'userId': userId,
    };
  }
}