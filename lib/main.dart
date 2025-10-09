import 'package:flutter/material.dart';
import 'package:todo_app/screens/auth/login_screen.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/services/auth_service.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final token = await AuthService.getToken();

  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {

  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Todo List Application',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),

      debugShowCheckedModeBanner: false,
    );
  }
}