import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/screens/auth/login_screen.dart';

import '../../models/user.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late String name;
  late String username;
  late String email;
  late String password;

  void registerUser() async{
      if(_formKey.currentState!.validate()){

        setState(() {
          _isLoading = true;
        });

        final user = User.register(
          name: name,
          username: username,
          email: email,
          password: password,
        );

        bool results = await AuthService.register(user);

        setState(() {
          _isLoading = false;
        });

        if(results == true) {
          setState(() {
            _isLoading = false;
          });
          Get.to(LoginScreen());
          Get.snackbar(
            "Success",
            "Your account has been successfully created!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: EdgeInsets.all(15),
            icon: Icon(Icons.message, color: Colors.white,),
          );
        }else{
          Get.snackbar(
            "Error",
            "An error occurred during the process, please kindly try again!",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(15),
            icon: Icon(Icons.message, color: Colors.white,),
          );
        }
      }else{
        Get.snackbar(
          "Validation",
          "Please fill in all the required fields!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(15),
          icon: Icon(Icons.message, color: Colors.white,),
        );
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
                    "CREATE ACCOUNT",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4
                    ),
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                    onChanged: (value){
                      name = value;
                    },
                    validator: (value){
                      if(value!.isEmpty) {
                        return "Name must not be empty!" ;
                      } else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        label: Text(
                          "Enter name",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2
                          ),
                        ),
                        focusColor: Colors.blue,
                        prefixIcon: Icon(
                          Icons.person_2_rounded,
                          color: Colors.white,
                        )
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
                              letterSpacing: 2
                          ),
                        ),
                        focusColor: Colors.blue,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        )
                    ),
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                    onChanged: (value){
                      email = value;
                    },
                    validator: (value){
                      if(value!.isEmpty) {
                        return "Email must not be empty!" ;
                      } else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        label: Text(
                          "Enter email",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2
                          ),
                        ),
                        focusColor: Colors.blue,
                        prefixIcon: Icon(
                          Icons.email,
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
                              letterSpacing: 2
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
                       registerUser();
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
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              letterSpacing: 4,
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
                            return LoginScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Already having an account ?  Login",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
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
