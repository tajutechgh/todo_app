import 'package:todo_app/endpoints/platform_os.dart';

class BaseUrl {

  static const String _androidBase = "http://10.0.2.2:8080";
  static const String _iosBase = "http://localhost:8080";
  static const String _defaultBase = "https://api.default-app.com";

  static String get base {

    if (PlatformOs.isAndroid) return _androidBase;

    if (PlatformOs.isIOS) return _iosBase;

    return _defaultBase;
  }

  // Authentication Endpoints
  static String get login => "$base/api/v1/auth/login";
  static String get register => "$base/api/v1/auth/register";

  // Todo Endpoints
  static String deleteTodo(int id) => "$base/api/v1/todos/delete/$id";
  static String get getAllTodos => "$base/api/v1/todos/all";
  static String get getAllCompletedTodos => "$base/api/v1/todos/completed";
  static String get getAllPendingTodos => "$base/api/v1/todos/pending";
  static String get getAllPaginatedTodos => "$base/api/v1/todos/all-todos";
  static String getTodoById(int id) => "$base/api/v1/todos/get/$id";
  static String updateTodosCompleteStatus(int id) => "$base/api/v1/todos/complete/$id";
  static String updateTodosPendingStatus(int id) => "$base/api/v1/todos/incomplete/$id";
  static String get createTodos => "$base/api/v1/todos/create";
  static String updateTodo(int id) => "$base/api/v1/todos/update/$id";

  // User Endpoints
  static String deleteUser(int id) => "$base/api/v1/users/delete/$id";
  static String get getAllUsers => "$base/api/v1/users/all";
  static String getUserById(int id) => "$base/api/v1/users/get/$id";
  static String get createUser => "$base/api/v1/users/create";
  static String updateUser(int id) => "$base/api/v1/users/update/$id";
  static String get getUserProfile => "$base/api/v1/users/profile";
  static String get getCurrentUserData => "$base/api/v1/users/profile";
  static String updateUserProfile(int id) => "$base/api/v1/users/profile/update/$id";
}