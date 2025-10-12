import 'package:flutter/material.dart';

import '../../models/todo.dart';
import '../../services/todo_service.dart';

class PendingTodoWidget extends StatefulWidget {

  const PendingTodoWidget({super.key});

  @override
  State<PendingTodoWidget> createState() => _PendingTodoWidgetState();
}

class _PendingTodoWidgetState extends State<PendingTodoWidget> {

  late Future<List<Todo>>  futurePendingTodos;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  ListTileTitleAlignment? titleAlignment;

  @override
  void initState() {
    super.initState();
    refreshPendingTodos();
  }

  void refreshPendingTodos(){
    setState(() {
      futurePendingTodos = TodoService.fetchAllPendingTodos();
    });
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(

        future: futurePendingTodos,

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Center(child: CircularProgressIndicator());

          } else if (snapshot.hasError) {

            return Center(child: Text('Error: ${snapshot.error}'));

          } else if (snapshot.data == null || snapshot.data!.isEmpty) {

            return const Center(child: Text('No pending todo list found'));

          } else {

            final todos = snapshot.data!;

            return ListView.builder(

                itemCount: todos.length,

                itemBuilder: (context, index){

                  final todo = todos[index];

                  return Column(
                    children: [
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        color: Colors.pinkAccent,
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

                                },
                                value: ListTileTitleAlignment.top,
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle_outline, color: Colors.green, size: 30,),
                                    Text("Complete", style: TextStyle(fontSize: 15, letterSpacing: 1),)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );

                });
          }
        }
    );
  }
}
