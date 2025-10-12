import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/screens/auth/register_screen.dart';
import 'package:todo_app/services/auth_service.dart';

import '../../models/user.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late String username;
  late String password;

 void loginUser() async{
    if(_formKey.currentState!.validate()){

      setState(() {
        _isLoading = true;
      });

      final user = User.login(
        username: username,
        password: password,
      );

      bool results = await AuthService.login(user);

      setState(() {
        _isLoading = false;
      });

      if(results == true){

        setState(() {
          _isLoading = false;
        });

        Get.to(HomeScreen());

        Get.snackbar(
          "Login Success",
          "You have successfully login to your account!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: EdgeInsets.all(15),
          icon: Icon(Icons.message, color: Colors.white,),
        );

      }else{

        Get.snackbar(
          "Authentication Error",
          "Please check your credentials very well!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(15),
          icon: Icon(Icons.message, color: Colors.white,),
        );

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      body: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "TODO LIST LOGIN",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2
                    ),
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                     onChanged: (value){
                       username = value;
                     },
                    validator: (value){
                       if(value!.isEmpty) {
                         return "Username must not be empty!" ;
                       } else{
                         return null;
                       }
                    },
                    decoration: InputDecoration(
                      label: Text(
                        "Enter username",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1
                        ),
                      ),
                      focusColor: Colors.blue,
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.white,
                      )
                    ),
                  ),
                  SizedBox(height: 30,) ,
                  TextFormField(
                    obscureText: true,
                    onChanged: (value){
                      password = value;
                    },
                    validator: (value){
                      if(value!.isEmpty) {
                        return "Password must not be empty!" ;
                      } else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        label: Text(
                          "Enter password",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1
                          ),
                        ),
                        focusColor: Colors.blue,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        )
                    ),
                  ),
                  SizedBox(height: 30,),
                  InkWell(
                    onTap: (){
                       loginUser();
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width-20,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                      )
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  TextButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                              return RegisterScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Don't have an account? Register",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
          ),
      )
    );
  }
}
