import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String username;
  late String password;

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
                      letterSpacing: 4
                    ),
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                     onChanged: (value){
                       username = value;
                     },
                    validator: (value){
                       if(value!.isEmpty) {
                         
                         return "Username or email must not be empty!" ;

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
                  SizedBox(height: 30,) ,
                  TextFormField(
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
                      "Don't have an account ?  Register",
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
