import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
           ),
         ),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        children: [
          Text("Welcome To Todo List Home Page"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
