class User {
  final String name;
  final String phoneNumber;
  final String email;
  final String password;
  User({this.name, this.phoneNumber, this.email, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        phoneNumber: json['phonNumber'],
        email: json["email"],
        password: json['password']);
  }
}
