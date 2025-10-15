import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/screens/widgets/cascading_menu_widget.dart';
import 'package:todo_app/services/user_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  
  late Future<User> futureCurrentUserData;

  bool _isLoading = false;

  int? userId;
  String? name;
  String? username;
  String? email;
  
  String? password;
  String? role;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _refreshCurrentUserData();
  }
  
  void _refreshCurrentUserData(){
    setState(() {
      futureCurrentUserData = UserService.getCurrentUserData();
    });
  }

  Future<void> _loadProfile() async {
    
    final profile = await UserService.fetchUserProfile();

    if (mounted) {
      setState(() {
        userId = profile?['id'];
        name = profile?['name'];
        username = profile?['username'];
        email = profile?['email'];
        password = profile?['password'];
        role = profile?['role'];
        isLoading = false;
      });
    }
  }

  // editing user profile
  void showUpdateUserProfileDialog({User? user}) {

    nameController.text = user?.name?? "";
    emailController.text = user?.email??"";

    showDialog(context: context, builder: (context) {
      return AlertDialog(
        
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "Update Profile",
              style: TextStyle(
                letterSpacing: 1,
                fontSize: 30,
              ),
            ),
          ],
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter name',
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
              ),
            ),
            SizedBox(height: 15,),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter email',
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
              ),
            ),
          ],
        ),

        actions: [
          ElevatedButton(
            onPressed: Navigator.of(context).pop,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {

              final currentUserName = nameController.text.trim();
              final currentUserEmail = emailController.text.trim();

              if (currentUserName.isEmpty || currentUserEmail.isEmpty) return;

              if (user != null) {

                  User? results = await UserService.updateCurrentUserProfile(
                    user.id!,
                    User.currentUserProfile(id: user.id, name: currentUserName, username: user.username, email: currentUserEmail),
                  );

                  setState(() => _isLoading = false);

                  if (results != null) {
                    Get.snackbar(
                      "Update Profile",
                      "You have successfully updated your profile!",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      margin: EdgeInsets.all(15),
                      icon: Icon(Icons.message, color: Colors.white,),
                    );
                  } else {
                    Get.snackbar(
                      "Update Profile",
                      "An error occurred while updating your profile!",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: EdgeInsets.all(15),
                      icon: Icon(Icons.message, color: Colors.white,),
                    );
                  }
               }

              if (mounted) {

                if (context.mounted) {
                  Navigator.of(context).pop();
                }

                _loadProfile();
                _refreshCurrentUserData();
              }
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),

            child: Text("Update Profile"),
          ),
        ],
      );
    },
    );
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
      body: FutureBuilder<User>(
        future: futureCurrentUserData,
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            
            return const Center(child: CircularProgressIndicator());
            
          } else if (snapshot.hasError) {
            
            return Center(child: Text('Error: ${snapshot.error}'));
            
          } else if (snapshot.data == null) {
            
            return const Center(child: Text('No albums found'));
            
          } else {
            
            final user = snapshot.data;

            return isLoading
                ? const Center(
                child: CircularProgressIndicator(color: Colors.purpleAccent))
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
                          showUpdateUserProfileDialog(user: user);
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
            );
          }
        }
      ),
    );
  }
}
