import 'package:flutter/material.dart';
import 'package:todo_app/screens/widgets/cascading_menu_widget.dart';
import 'package:todo_app/screens/widgets/completed_todo_widget.dart';
import 'package:todo_app/screens/widgets/pending_todo_widget.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
         title: Text(
           "Todo List",
           style: TextStyle(
             color: Colors.white,
             fontSize: 24,
             fontWeight: FontWeight.bold,
             letterSpacing: 2,
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
              letterSpacing: 2,
          ),
          tabs: [
            Tab(icon: Icon(Icons.list, color: Colors.redAccent, fontWeight: FontWeight.bold, size: 30,), text: "Pending",),
            Tab(icon: Icon(Icons.list, color: Colors.green, fontWeight: FontWeight.bold, size: 30,), text: "Completed",),
          ],
        ),
        backgroundColor: Colors.purpleAccent,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: PendingTodoWidget()),
          Center(child: CompletedTodoWidget()),
        ],
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
