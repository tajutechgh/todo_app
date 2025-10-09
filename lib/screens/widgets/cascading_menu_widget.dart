import 'package:flutter/material.dart';
import 'package:todo_app/screens/auth/login_screen.dart';
import 'package:todo_app/services/auth_service.dart';

class CascadingMenuWidget extends StatefulWidget {

  const CascadingMenuWidget({super.key});

  @override
  State<CascadingMenuWidget> createState() => _CascadingMenuWidgetState();
}

class _CascadingMenuWidgetState extends State<CascadingMenuWidget> {

  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MenuAnchor(

      childFocusNode: _buttonFocusNode,

      menuChildren: [
        MenuItemButton(
            onPressed: () async {
              await AuthService.logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context){
                      return LoginScreen();
                    })
                );
              }
            },
            child: Row(
              children: [
                Icon(Icons.logout, color: Colors.red, size: 20,),
                Text(
                    'Logout',
                     style: TextStyle(
                       letterSpacing: 2,
                       fontSize: 15,
                       fontWeight: FontWeight.bold,
                     ),
                ),
              ],
            )
        ),
      ],

      builder: (_, MenuController controller, Widget? child) {

        return IconButton(

          focusNode: _buttonFocusNode,

          onPressed: () {

            if (controller.isOpen) {

              controller.close();

            } else {

              controller.open();
            }
          },

          icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
              fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}
