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

  http.StreamedResponse futureResponse;
  String responsBody= '<empty>';
  String error='<empty>';
  bool panding= false;

  bool showPassword = true;
  String name;
  String phoneNumber;
  String email;
  String password;
  User user;
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
      key: scaffoldKey,
      backgroundColor: Colors.blueGrey,
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
            padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 16.0),
          child: Form(
            key: formKey,
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
                    border: UnderlineInputBorder(),
                    filled: true,
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
                  onSaved: (String value) {
                    this.name = value;
                    print('name=$name');
                  },
                  validator: validateName,
                ),

                const SizedBox(height: 24.0),
                // "Phone number" form.
                TextFormField(
                  controller: phoneNumberController,
                  maxLength: 10,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.phone, color: Colors.white),
                    hintText: 'How can we reach you?',
                    hintStyle: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'OpenSans',
                    ),
                    labelText: 'Phone Number *',
                    helperText: "Start with 09",
                    helperStyle: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'OpenSans',
                    ),
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Phone number is Required.';
                    }
                    if (value.length < 10) {
                      return 'invalid phone number';
                    }
                    return null;
                  },
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
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.email, color: Colors.white),
                    hintText: 'Your email address',
                    hintStyle: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'OpenSans',
                    ),
                    labelText: 'E-mail *',
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
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: true,
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
                          switch (futureResponse.statusCode) {
                            case 200:
                              user = new User();
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) {
                                  return LoginPage();
                                },
                              ));
                              break;
                            case 400:
                              var body_str = await futureResponse.stream.bytesToString();
                              dynamic body_json = jsonDecode(body_str);
                              showSnackBar(
                                  "message: " + body_json["message"] + "\n"
                                  "attribute: " + body_json["attribute"] + "\n"
                                  "error: " + body_json["error"]
                              );
                              break;
                            default:
                              showSnackBar(
                                  "Something went wrong, try again");
                          }
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
                Divider(),
              ],
            ),

          ),
      ),
        ),
    ],

    ),
    );
  }

  Future<http.StreamedResponse> RegUser(
      String name, String phoneNumber, String email, String password) async {
    var rl = Uri(
        scheme: 'http',
        host: '192.168.43.19',
        path: 'api/register');

    var req = http.MultipartRequest("POST", rl);
    req.fields.addAll({
      "uname": name,
      "pno": phoneNumber,
      "email": email,
      "passwd": password,
      "role": "user",
    });

    var response = await req.send();

//    print("I got " + await response.stream.bytesToString());
  return response;
  }
  void showSnackBar(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: "Close",
          textColor: Colors.white,
          onPressed: () {},
        ),
        content: (Text(message))));
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
