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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await AuthService.fetchUserProfile();

    if (mounted) {
      setState(() {
        name = profile?['name'];
        username = profile?['username'];
        email = profile?['email'];
        role = profile?['role'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: const [CascadingMenuWidget()],
        backgroundColor: Colors.purpleAccent,
        elevation: 2,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.purpleAccent))
          : RefreshIndicator(
        color: Colors.purpleAccent,
        onRefresh: _loadProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Avatar Section
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.purpleAccent,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 16),

              // Name and Username
              Text(
                name ?? 'Unknown User',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '@${(username ?? 'username').toLowerCase()}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              // Profile Info Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.email,
                            color: Colors.purpleAccent),
                        title: const Text('Email'),
                        subtitle: Text(email ?? 'Not provided'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.badge,
                            color: Colors.purpleAccent),
                        title: const Text('App Role'),
                        subtitle: Text(role ?? 'Not assigned'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Edit Profile Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to Edit Profile Screen
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
