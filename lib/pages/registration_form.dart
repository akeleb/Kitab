import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kitabui/models/User.dart';
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
  String responsBody = '<empty>';
  String error = '<empty>';
  bool panding = false;
  var isRequesting = false;

  bool showPassword = true;
  String name;
  String phoneNumber;
  String email;
  String password;
  User user;

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String validateName(String value) {
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = RegExp(r'^[a-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return 'Please enter only small alphabetical characters.';
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
              padding:
                  EdgeInsets.symmetric(vertical: 50.0, horizontal: 16.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 49.0),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
                      width: double.infinity,
                      child: Text(
                        'Welcome to Kitab',
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
                      decoration: InputDecoration(
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
                      onSaved: (String value) {
                        this.name = value;
                        print('name=$name');
                      },
                      validator: validateName,
                    ),

                    SizedBox(height: 24.0),
                    // "Phone number" form.
                    TextFormField(
                      controller: phoneNumberController,
                      maxLength: 10,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
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
                        FilteringTextInputFormatter.digitsOnly,
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
                    ), SizedBox(height: 24.0),
                    // "Email" form.
                    TextFormField(
                      controller: emailController,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
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

                    SizedBox(height: 24.0),
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
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Password is Required.';
                        }
                        else if (!RegExp('^[a-zA-Z0-9.]{4,32}\$').hasMatch(value)) {
                          return "Minimum of 4 charachters";
                        }

                        return null;
                      },
                      onSaved: (String value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    SizedBox(height: 50.0),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 75.0),
                      width: double.infinity,
                      child: Form(
                        child: RaisedButton(
                          elevation: 5.0,
                          onPressed: () async {
                            if (formKey.currentState.validate()) {
                              setState(() {
                                isRequesting = true;
                              });
                              try {
                                futureResponse = await RegUser(
                                    userNameController.text,
                                    phoneNumberController.text,
                                    emailController.text,
                                    passwordController.text);
                              } catch (e) {
                                setState(() {
                                  isRequesting = false;
                                });
                                showSnackBar(
                                  ('error: $e'),
                                );
                              }
                              switch (futureResponse.statusCode) {
                                case 200:
                                  setState(() {
                                    isRequesting = false;
                                  });
                                  user = new User();
                                  showSnackBar("Well Come "+ userNameController.text);
                                  Timer(Duration(seconds: 2), () {
                                    Navigator.pop(context);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return LoginPage();
                                      },
                                    ));
                                  });

                                  break;
                                case 400:
                                  setState(() {
                                    isRequesting = false;
                                  });
                                  var body_str = await futureResponse.stream
                                      .bytesToString();
                                  dynamic body_json = jsonDecode(body_str);
                                  showSnackBar(body_json["message"] + "\nplease make sure"
                                      " you have enterd the correct "+body_json["attribute"]);
                                  break;
                                default:
                                  showSnackBar(
                                      "Something went wrong, try again");
                                  setState(() {
                                    isRequesting = false;
                                  });
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
                    isRequesting
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox(height: 60),
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
    var rl = Uri(scheme: 'http', host: '10.2.64.163', path: 'api/register');

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
        action: SnackBarAction(
          label: "Close",
          textColor: Colors.white,
          onPressed: () {},
        ),
        content: (Text(message))));
  }
}
