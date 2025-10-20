import 'package:flutter/material.dart';
import 'package:todo_app/screens/admin_navigation_screen.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/services/auth_service.dart';

class TodoMainScreen extends StatefulWidget {
  const TodoMainScreen({super.key});

  @override
  State<TodoMainScreen> createState() => _TodoMainScreenState();
}

class _TodoMainScreenState extends State<TodoMainScreen> {

  String? _role;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    
    final role = await AuthService.getUserRole();
    
    setState(() {
      _role = role;
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Role-based routing
    if (_role == "ADMIN") {
      
      return const AdminNavigationScreen();
      
    } else if (_role == "USER") {
      
      return const HomeScreen();
      
    } else {
      // fallback
      return const Scaffold(
        
        body: Center(child: Text('No role assigned')),
      );
    }
  }
}
