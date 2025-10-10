import 'package:flutter/material.dart';
import 'package:todo_app/screens/widgets/cascading_menu_widget.dart';

import '../services/auth_service.dart';

class UserProfileScreen extends StatefulWidget {

  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String? name;
  String? username;
  String? email;
  String? role;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }
  Future<void> _loadProfile() async {

    final profile = await AuthService.fetchUserProfile();

    if (profile != null) {
      setState(() {
        name = profile['name'];
        username = profile['username'];
        email = profile['email'];
        role = profile['role'];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text(
            "My Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
        ),
        actions: [
          CascadingMenuWidget()
        ],
        backgroundColor: Colors.purpleAccent,
      ),
      body: Card(
        child: Column(
           children: [
             Text("$name"),
             Text("$username"),
             Text("$email"),
             Text("$role"),
           ],
        ),
      ),
    );
  }
}
