import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kitabui/pages/login_screen.dart';

class Register extends StatefulWidget {
  const Register({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<Register> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  http.Response futureResponse;
  String responsBody= '<empty>';
  String error='<empty>';
  bool panding= false;

  bool showPassword = true;
  String name;
  String phoneNumber;
  String email;
  String password;

  String validateName(String value) {
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return 'Please enter only alphabetical characters.';
    }
    return null;
  }

  String validateEmail(String value) {
    final RegExp emailExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`"
        r"{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (value.isEmpty) {
      return "Email is Required";
    } else if (!emailExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 60.0),
              // "Name" form.
              TextFormField(
                controller: userNameController,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  fillColor: Colors.teal,
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.person, color: Colors.white),
                  hintText: 'Enter your name',
                  hintStyle: TextStyle(
                    color: Colors.white70,
                    fontFamily: 'OpenSans',
                  ),
                  labelText: 'Name *',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                ),
                onSaved: (String value) {
                  this.name = value;
                  print('name=$name');
                },
                validator: validateName,
              ),

              const SizedBox(height: 24.0),
              // "Phone number" form.
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
                decoration: const InputDecoration(
                  fillColor: Colors.teal,
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.phone, color: Colors.white),
                  hintText: 'Where can we reach you?',
                  hintStyle: TextStyle(
                    color: Colors.white70,
                    fontFamily: 'OpenSans',
                  ),
                  labelText: 'Phone Number *',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                ),
                keyboardType: TextInputType.phone,
                onSaved: (String value) {
                  this.phoneNumber = value;
                  print('phoneNumber=$phoneNumber');
                },

                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 24.0),
              // "Email" form.
              TextFormField(
                controller: emailController,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
                decoration: const InputDecoration(
                  fillColor: Colors.teal,
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.email, color: Colors.white),
                  hintText: 'Your email address',
                  hintStyle: TextStyle(
                    color: Colors.white70,
                    fontFamily: 'OpenSans',
                  ),
                  labelText: 'E-mail',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (String value) {
                  this.email = value;
                  print('email=$email');
                },
                validator: validateEmail,
              ),

              const SizedBox(height: 24.0),
              // "Password" form.
              TextFormField(
                controller: passwordController,
                obscureText: showPassword,
                decoration: InputDecoration(
                  fillColor: Colors.teal,
                  border: const UnderlineInputBorder(),
                  filled: true,
                  hintText: ("Enter your password"),
                  hintStyle: TextStyle(
                    color: Colors.white70,
                    fontFamily: 'OpenSans',
                  ),
                  labelText: ("Password"),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                  helperText: "Not less than 4 characters",
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    color: showPassword ? Colors.blueGrey : Colors.red,
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Password is Required.';
                  }
                  if (value.length < 4) {
                    return 'Password too short.';
                  }
                  return null;
                },
                onSaved: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 60.0),
              Container(
                padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 75.0),
                width: double.infinity,
                child: Form(
                  child: RaisedButton(
                    elevation: 5.0,
                    onPressed: () async{
                      if (formKey.currentState.validate()) {
                        futureResponse = await RegUser(
                            userNameController.text,
                            phoneNumberController.text,
                            emailController.text,
                            passwordController.text);
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) {
                            return LoginPage();
                          },
                        ));
                      }
                    },
                    //        => print('Login Button Pressed'),
                    padding: EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    color: Colors.greenAccent,
                    child: Text(
                      'REGISTER',
                      style: TextStyle(
                        color: Colors.indigo,
                        letterSpacing: 1.5,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),

                ),
              ),
              Text(responsBody),
              Divider(),
              Text(error),
            ],
          ),

        ),
      ),
    );
  }

  Future<http.Response> RegUser(
      String name, String phoneNumber, String email, String password) async {
    var rl = Uri.parse('http://192.198.43.65:90/api/register');

    http.get(rl);

    final http.Response response = await http.post(
      rl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "uname": name,
        "pho": phoneNumber,
        "email": email,
        "passwd": password,
      }),
    );
    print("I got " + response.body);
  return response;
  }
}

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
