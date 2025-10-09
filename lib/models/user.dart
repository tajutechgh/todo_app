class User{

  String? name;
  String? username;
  String? email;
  String? password;

  User.register({
    required this.name,
    required this.username,
    required this.email,
    required this.password
  });

  User.login({
    required this.username,
    required this.password,
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