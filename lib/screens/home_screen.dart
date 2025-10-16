import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/screens/widgets/cascading_menu_widget.dart';
import 'package:todo_app/screens/widgets/completed_todo_widget.dart';
import 'package:todo_app/screens/widgets/pending_todo_widget.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/services/user_service.dart';

import '../models/todo.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  late int userId;
  String? username;

  late final TabController _tabController;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  late Future<List<Todo>>  futurePendingTodos;
  late Future<List<Todo>>  futureCompletedTodos;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _refreshTodos();
    _loadCurrentUserName();
    _loadUserProfile();
  }

  void _refreshTodos(){
    setState(() {
      futurePendingTodos = TodoService.fetchAllPendingTodos();
      futureCompletedTodos = TodoService.fetchAllCompletedTodos();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // load current user data
  Future<void> _loadCurrentUserName() async {
    
    final name = await AuthService.getCurrentUsername();

    setState(() {
      username = name;
    });
  }

  // load current user profile
  Future<void> _loadUserProfile() async {

    final profile = await UserService.fetchUserProfile();

    if (profile != null) {
      setState(() {
        userId = profile['id'];
      });
    }
  }

  // creating and editing dialog function
  Future<void> showTodoDialog([Todo? todo]) async {

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

                  setState(() => _isLoading = false);

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

                    setState(() => _isLoading = false);

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
         title: Text(
           username != null ? "Welcome User, $username" : "Todo List",
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
        bottom: TabBar(
          controller: _tabController,
          labelStyle: TextStyle(
              fontSize: 20,
              color: Colors.white,
              letterSpacing: 1,
          ),
          tabs: [
            Tab(icon: Icon(Icons.list, color: Colors.red, fontWeight: FontWeight.bold, size: 30,), text: "Pending",),
            Tab(icon: Icon(Icons.list, color: Colors.green, fontWeight: FontWeight.bold, size: 30,), text: "Completed",),
          ],
        ),
        backgroundColor: Colors.purpleAccent,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: PendingTodoWidget(
              onRefresh: ([todo])  async {
                await showTodoDialog(todo);
              }
          )),
          Center(child: CompletedTodoWidget(
              onRefresh: ([todo])  async {
                await showTodoDialog(todo);
              }
          )),
        ],
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
