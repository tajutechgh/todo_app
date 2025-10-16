import 'package:flutter/material.dart';
import 'package:todo_app/services/todo_service.dart';

import '../models/todo.dart';
import '../services/auth_service.dart';
import 'widgets/cascading_menu_widget.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {

  late Future<List<Todo>>  futureTodos;
  bool _loading = true;

  String? username;

  String? role;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserName();
    _loadRole();
    _refreshTodos();
  }

  Future<void> _loadCurrentUserName() async {
    
    final name = await AuthService.getCurrentUsername();

    setState(() {
      username = name;
    });
  }

  Future<void> _loadRole() async {

    final currentUserRole = await AuthService.getUserRole();

    setState(() {
      role = currentUserRole;
    });
  }

  void _refreshTodos() {
    
    setState(() {
      futureTodos = TodoService.fetchAllTodos();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          title: Text(
            username != null ? "Welcome $role, $username" : "Admin Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          actions: [
            CascadingMenuWidget()
          ],
          backgroundColor: Colors.purpleAccent,
        ),
       body: _loading ? const Center(child: CircularProgressIndicator()) : FutureBuilder<List<Todo>>(
         future: futureTodos,
         
         builder: (context, snapshot) {

           if (snapshot.connectionState == ConnectionState.waiting) {

             return const Center(child: CircularProgressIndicator());

           } else if (snapshot.hasError) {

             return Center(child: Text('Error: ${snapshot.error}'));

           } else if (snapshot.data == null || snapshot.data!.isEmpty) {

             return const Center(child: Text('No todos found'));

           } else {

             final todos = snapshot.data!;

             return ListView.builder(
               
               itemCount: todos.length,

               itemBuilder: (context, index) {

                 final todo = todos[index];

                 return Card(
                   color:   todo.completed == true? Colors.orange : Colors.greenAccent,
                   margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),

                   child: ListTile(

                     title: Text(
                         todo.title,
                       style: TextStyle(
                           fontSize: 15,
                           fontWeight: FontWeight.bold,
                           letterSpacing: 1,
                           color: Colors.white
                       ),
                     ),
                     subtitle: Text(
                         todo.description,
                       style: TextStyle(
                           fontSize: 13,
                           letterSpacing: 1,
                           color: Colors.white
                       ),
                     ),
                     trailing: Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         IconButton(
                           icon: const Icon(Icons.edit, color: Colors.green),
                           onPressed: () {
                             
                           },
                         ),
                         IconButton(
                           icon: const Icon(Icons.delete, color: Colors.red),
                           onPressed: () {

                           },
                         ),
                         IconButton(
                           icon: const Icon(Icons.check_circle, color: Colors.green),
                           onPressed: () {

                           },
                         ),
                         IconButton(
                           icon: const Icon(Icons.cancel, color: Colors.red),
                           onPressed: () {

                           },
                         ),
                       ],
                     ),
                   ),
                 );
               },
             );
           }
         },
       ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
         
        },
        backgroundColor: Colors.purpleAccent,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
