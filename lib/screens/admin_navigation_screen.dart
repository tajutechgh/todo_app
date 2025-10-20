import 'package:flutter/material.dart';
import 'package:todo_app/screens/admin_dashboard_screen.dart';
import 'package:todo_app/screens/admin_manage_users_screen.dart';

class AdminNavigationScreen extends StatefulWidget {
  
  const AdminNavigationScreen({super.key});

  @override
  State<AdminNavigationScreen> createState() => _AdminNavigationScreenState();
}

class _AdminNavigationScreenState extends State<AdminNavigationScreen> {
  
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 120,
        elevation: 10.0,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        backgroundColor: Colors.purpleAccent,
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.dashboard,
              color: Colors.white,
              size: 30,
            ),
            label: 'Todo List',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.supervisor_account,
              color: Colors.white,
              size: 30,
            ),
            label: 'Manage Users',
          ),
        ],
      ),
      body: [
        
        /// Todo list page
        AdminDashboardScreen(),

        /// Manage users page
        AdminManageUsersScreen(),
        
      ][currentPageIndex],
    );
  }
}
