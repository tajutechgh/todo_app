import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/services/todo_service.dart';

import '../models/todo.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'widgets/cascading_menu_widget.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isFormLoading = false;

  late Future<List<Todo>>  futureTodos;
  
  bool _loading = true;

  String? username;

  String? role;

  int? userId;
  String? name;
  String? email;
  String? password;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserName();
    _loadRole();
    _refreshTodos();
    _loadProfile();
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

  Future<void> _loadProfile() async {

    final profile = await UserService.fetchUserProfile();

    if (mounted) {
      setState(() {
        userId = profile?['id'];
        name = profile?['name'];
        email = profile?['email'];
        password = profile?['password'];
        isLoading = false;
      });
    }
  }

  void _refreshTodos() {
    
    setState(() {
      futureTodos = TodoService.fetchAllTodos();
      _loading = false;
    });
  }

  // creating and editing dialog function
  void showTodoDialog({Todo? todo}) {

    setState(() {
      _isFormLoading = true;
    });

    titleController.text = todo?.title?? "";
    descriptionController.text = todo?.description?? "";

    showDialog(context: context, builder: (context) {
      return Form(
        key: formKey,
        child: AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                todo == null ? 'Add Todo' : 'Edit Todo',
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
              TextFormField(
                controller: titleController,
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }else{
                    return null;
                  }
                },
                decoration: const InputDecoration(labelText: 'Todo Title'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: descriptionController,
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }else{
                    return null;
                  }
                },
                decoration: const InputDecoration(labelText: 'Todo Description'),
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

                if (!formKey.currentState!.validate()) return;

                final title = titleController.text.trim();
                final description = descriptionController.text.trim();

                if (todo == null) {
                  Todo? results = await TodoService.createTodo(
                    Todo(title: title, description: description, completed: false, userId: userId),
                  );

                  setState(() => _isFormLoading = false);

                  if (results != null) {
                    Get.snackbar(
                      "Create Todo",
                      "You have successfully created new todo!",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      margin: EdgeInsets.all(15),
                      icon: Icon(Icons.message, color: Colors.white,),
                    );
                  } else {
                    Get.snackbar(
                      "Create Todo",
                      "An error occurred while creating todo!!",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: EdgeInsets.all(15),
                      icon: Icon(Icons.message, color: Colors.white,),
                    );
                  }
                } else {

                  if (!formKey.currentState!.validate()) return;

                  final title = titleController.text.trim();
                  final description = descriptionController.text.trim();

                  if (todo.id != null) {
                    Todo? results = await TodoService.updateTodo(
                      todo.id!,
                      Todo(title: title, description: description, completed: todo.completed, userId: todo.userId),
                    );

                    setState(() => _isFormLoading = false);

                    if (results != null) {
                      Get.snackbar(
                        "Update Todo",
                        "You have successfully updated the todo!",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        margin: EdgeInsets.all(15),
                        icon: Icon(Icons.message, color: Colors.white,),
                      );
                    } else {
                      Get.snackbar(
                        "Update Todo",
                        "An error occurred while updating todo!!",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: EdgeInsets.all(15),
                        icon: Icon(Icons.message, color: Colors.white,),
                      );
                    }
                  }
                }

                if (context.mounted) {

                  Navigator.of(context).pop();

                  _refreshTodos();
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),

              child: Text(todo == null ? 'Save Todo' : 'Update Todo'),
            ),
          ],
        ),
      );
    },
    );
  }

  // deleting function
  Future<void> deleteTodo(int? id) async {

    if (id == null) return;

    await TodoService.deleteTodo(id);

    _refreshTodos();

    Get.snackbar(
      "Delete Todo",
      "You have successfully deleted this todo!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: EdgeInsets.all(15),
      icon: Icon(Icons.message, color: Colors.white,),
    );
  }

  // check pending todo completed function
  Future<void> completedTodo(int? id) async {

    if (id == null) return;

    await TodoService.completeTodo(id);

    _refreshTodos();

    Get.snackbar(
      "Complete Todo",
      "You have successfully completed this todo!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: EdgeInsets.all(15),
      icon: Icon(Icons.message, color: Colors.white,),
    );
  }

  // check complete todo to pending function
  Future<void> pendingTodo(int? id) async {

    if (id == null) return;

    await TodoService.pendingTodo(id);

    _refreshTodos();

    Get.snackbar(
      "Pending Todo",
      "You have successfully pend this todo!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: EdgeInsets.all(15),
      icon: Icon(Icons.message, color: Colors.white,),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          title: Text(
            username != null ? "Welcome Admin, $username" : "Admin Dashboard",
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
                         if(todo.userId == userId)
                         IconButton(
                           icon: const Icon(Icons.edit, color: Colors.green),
                           onPressed: () {
                             showTodoDialog(todo: todo);
                           },
                         ),
                         if(todo.userId == userId)
                         IconButton(
                           icon: const Icon(Icons.delete, color: Colors.red),
                           onPressed: () {
                              deleteTodo(todo.id);
                           },
                         ),
                         if(todo.userId == userId)
                           if(todo.completed == false)
                           IconButton(
                             icon: const Icon(Icons.check_circle, color: Colors.green),
                             onPressed: () {
                                completedTodo(todo.id);
                             },
                           ),
                         if(todo.userId == userId)
                           if(todo.completed == true)
                           IconButton(
                             icon: const Icon(Icons.cancel, color: Colors.red),
                             onPressed: () {
                                 pendingTodo(todo.id);
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
          showTodoDialog();
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
