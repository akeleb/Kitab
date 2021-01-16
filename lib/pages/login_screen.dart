import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kitabui/pages/registration_form.dart';
import 'package:kitabui/pages/welcomescreen.dart';
import 'package:http/http.dart' as http;


class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool showPassword = true;
  var isRequesting = false;
  http.Response futureResponse;
  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff21254A),
                  Color(0xff21254A),
                  Color(0xff21254A),
                  //Colors.red,
                ],
                stops: [0.2, 0.6, 0.9],
              ),
            ),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 50.0,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
//                    key: formKey,
                  children: <Widget>[
                    SizedBox(height: 40.0),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 80.0),
                      width: double.infinity,
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),

                    TextFormField(
                      controller: userNameController,
                      cursorColor: Colors.red,
                      keyboardType: TextInputType.text,
                      //key: formKey,
                      // ignore: deprecated_member_use
                      autovalidate: false,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        icon: Icon(Icons.person, color: Colors.white),
                        hintText: 'Enter your user name',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'OpenSans',
                        ),
                        labelText: 'User Name *',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      validator: validateName,
                    ),

                    // buildUserNameTF(),

                    SizedBox(height: 30.0),

                    TextFormField(
                      controller: passwordController,
                      cursorColor: Colors.red,
                      obscureText: showPassword,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        hintText: ("Enter your password"),
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'OpenSans',
                        ),
                        labelText: ("Password *"),
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                        ),
                        helperText: "Not less than 4 characters",
                        helperStyle: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'OpenSans',
                      ),
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
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Password is Required.';
                        }
                        if (value.length < 4) {
                          return 'Password too short.';
                        }
                        return null;
                      },
                    ),

                    //buildPasswordTF(),
                    SizedBox(height: 30.0),
                             FlatButton(
                                 onPressed: null,
                                 child: Text("Forgot Password?",
                                   style: TextStyle(
                                     color: Colors.lightBlueAccent,
                                     letterSpacing: 1.5,
                                     fontSize: 20.0,
                                     fontWeight: FontWeight.bold,
                                     fontFamily: 'OpenSans',
                                   ),
                                 )
                             ),

                         Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 25.0, horizontal: 80.0),
                            width: double.infinity,
                            child: Form(
                              child: RaisedButton(
                                elevation: 5.0,
                                onPressed: () async {
                                  //validateAndSave();
                                  if (formKey.currentState.validate()) {
                                    setState(() {
                                      isRequesting = true;
                                    });
//                                    futureResponse = await LogInUser(
//                                        userNameController.text,
//                                        passwordController.text);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return WelcomeScreen();
                                      },
                                    ));

//                                    switch (futureResponse.statusCode) {
//                                      case 201:
//                                        user = new User();
//                                        User.fromJson(
//                                            jsonDecode(futureResponse.body));
//                                        Navigator.of(context)
//                                            .push(MaterialPageRoute(
//                                          builder: (context) {
//                                            return WelcomeScreen();
//                                          },
//                                        ));
//                                    }
                                  }
                                },
                                padding: EdgeInsets.all(15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                color: Colors.greenAccent,
                                child: Text(
                                  'LOGIN',
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
                    SizedBox(height: 30,),

                    Row(
                      children: [
                        Text(
                          "Haven't account?",
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'OpenSans',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 30),
                        FlatButton(
                          focusColor: Colors.pink,
                          onPressed:(){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Register();
                                },
                              ),
                            );
                          },
                          child: Text("Register",
                            style: TextStyle(
                              color: Colors.lightBlue,
                              fontFamily: 'OpenSans',
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),


                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  final formKey = new GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String validateName(String value) {
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return 'Please enter only alphabetical characters.';
    }
    return null;
  }

  Future<http.Response> LogInUser(String name, String password) async {
    final http.Response response = await http.post(
      'http://192.198.137.107/api/user/Login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "uname": name,
        "passwd": password,
      }),
    );
    return response;

//    if (response.statusCode == 201) {
//      return jsonDecode(response.body);
//    } else {
//      throw Exception('Failed to register.');
//    }
  }
}

class User {
  final String name;
  final String password;

  User({this.name, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(name: json['name'], password: json['password']);
  }
}
