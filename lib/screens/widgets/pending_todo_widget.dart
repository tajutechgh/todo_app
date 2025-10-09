import 'package:flutter/material.dart';

class PendingTodoWidget extends StatefulWidget {

  const PendingTodoWidget({super.key});

  @override
  State<PendingTodoWidget> createState() => _PendingTodoWidgetState();
}

class _PendingTodoWidgetState extends State<PendingTodoWidget> {

  ListTileTitleAlignment? titleAlignment;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Card(
          color: Colors.pinkAccent,
          child: ListTile(
            titleAlignment: titleAlignment,
            title: Text(
                'Headline Text',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white
                ),
            ),
            subtitle: Text(
              'Tapping on the trailing widget will show a menu that allows you to change the title alignment. ',
              style: TextStyle(
                fontSize: 15,
                letterSpacing: 2,
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
                      Text("Edit", style: TextStyle(fontSize: 15, letterSpacing: 2),)
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
                      Text("Delete", style: TextStyle(fontSize: 15, letterSpacing: 2),)
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
                      Text("Complete", style: TextStyle(fontSize: 15, letterSpacing: 2),)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
