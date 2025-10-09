class User{

  final String name;
  final String username;
  final String email;
  final String password;

  User({
    required this.name,
    required this.username,
    required this.email,
    required this.password
  });

  Map<String, dynamic> toLoginJson() {
    return {
      "usernameOrEmail": username,
      "password": password,
    };
  }

  Map<String, dynamic> toRegisterJson(){
    return {
      "name" : name,
      "username" : username,
      "email" : email,
      "password" : password,
    };
  }

}