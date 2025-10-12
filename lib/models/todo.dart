
class Todo {

  int? id;
  final String title;
  final String description;
  final bool completed;
  final int userId;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.userId
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
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