import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/services/todo_service.dart';

import '../../models/todo.dart';

class CompletedTodoWidget extends StatefulWidget {

  // use this to call the showTodoDialogue method from the home page
  final Future<void> Function([Todo? todo])? onRefresh;

  const CompletedTodoWidget({super.key,  this.onRefresh});

  @override
  State<CompletedTodoWidget> createState() => _CompletedTodoWidgetState();
}

class _CompletedTodoWidgetState extends State<CompletedTodoWidget> {

  late Future<List<Todo>>  futureCompletedTodos;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  ListTileTitleAlignment? titleAlignment;

  @override
  void initState() {
    super.initState();
    refreshCompletedTodos();
  }

  void refreshCompletedTodos(){
    setState(() {
      futureCompletedTodos = TodoService.fetchAllCompletedTodos();
    });
  }

  // deleting function
  Future<void> deleteCompletedTodo(int? id) async {

    if (id == null) return;

    await TodoService.deleteTodo(id);

    refreshCompletedTodos();

    Get.snackbar(
      "Delete Todo",
      "You have successfully deleted this todo!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: EdgeInsets.all(15),
      icon: Icon(Icons.message, color: Colors.white,),
    );
  }

  // deleting function
  Future<void> pendingTodo(int? id) async {

    if (id == null) return;

    await TodoService.pendingTodo(id);

    refreshCompletedTodos();

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

    return FutureBuilder(

      future: futureCompletedTodos,

      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {

          return const Center(child: CircularProgressIndicator());

        } else if (snapshot.hasError) {

          return Center(child: Text('Error: ${snapshot.error}'));

        } else if (snapshot.data == null || snapshot.data!.isEmpty) {

          return const Center(child: Text('No completed todo list found'));

        } else {

          final todos = snapshot.data!;

          return ListView.builder(

              itemCount: todos.length,

              itemBuilder: (context, index){

                final todo = todos[index];

                return RefreshIndicator(
                  onRefresh: widget.onRefresh ?? () async {},
                  child: Column(
                    children: [
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        color: Colors.deepOrangeAccent,
                        child: ListTile(
                          titleAlignment: titleAlignment,
                          title: Text(
                            //todo title
                            todo.title,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Colors.white
                            ),
                          ),
                          subtitle: Text(
                            //todo description
                            todo.description,
                            style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 1,
                                color: Colors.white
                            ),
                          ),
                          trailing: PopupMenuButton<ListTileTitleAlignment>(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(Colors.white),
                              elevation: WidgetStateProperty.all(4),
                            ),
                            onSelected: (ListTileTitleAlignment? value) {
                              setState(() {
                                titleAlignment = value;
                              });
                            },
                            itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<ListTileTitleAlignment>>[
                              PopupMenuItem<ListTileTitleAlignment>(
                                onTap: (){
                                  widget.onRefresh?.call(todo);
                                },
                                value: ListTileTitleAlignment.threeLine,
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.green, size: 30,),
                                    Text("Edit", style: TextStyle(fontSize: 15, letterSpacing: 1),)
                                  ],
                                ),
                              ),
                              PopupMenuItem<ListTileTitleAlignment>(
                                onTap: (){
                                  deleteCompletedTodo(todo.id);
                                },
                                value: ListTileTitleAlignment.titleHeight,
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red, size: 30,),
                                    Text("Delete", style: TextStyle(fontSize: 15, letterSpacing: 1),)
                                  ],
                                ),
                              ),
                              PopupMenuItem<ListTileTitleAlignment>(
                                onTap: (){
                                    pendingTodo(todo.id);
                                },
                                value: ListTileTitleAlignment.top,
                                child: Row(
                                  children: [
                                    Icon(Icons.cancel_outlined, color: Colors.red, size: 30,),
                                    Text("Pending", style: TextStyle(fontSize: 15, letterSpacing: 1),)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
          });
        }
      }
    );
  }
}
