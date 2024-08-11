class User {
  String? userId;
  String? email;
  String? password;

  User({this.userId, this.email, this.password});

  User.fromMap(Map<String, dynamic> map) {
    userId = map['userId'];
    email = map['email'];
    password = map['password'];
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'password': password,
    };
  }
  
}