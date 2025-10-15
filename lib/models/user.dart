class User{

  int? id;
  String? name;
  String? username;
  String? email;
  String? password;
  String? role;

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

  User.currentUserProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.role
  });

  factory User.fromJson(Map<String, dynamic> json){

    return User.currentUserProfile(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        email: json["email"]
    );

  }

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

  Map<String, dynamic> toUserJson() {
    return {
      "id": id,
      "name": name,
      "username": username,
      "email": email
    };
  }
}