import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kitabui/pages/registration_form.dart';
import 'package:kitabui/pages/welcomescreen.dart';
import 'package:kitabui/models/User.dart';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';
import '../consts.dart' as consts;


class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool showPassword = true;
  var isRequesting = false;
  http.StreamedResponse futureResponse;
  User user;
  String name;
  String phoneNumber;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
                        border: UnderlineInputBorder(),
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
                      onSaved: (String value) {
                        this.name = value;
                        print('name=$name');
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Password is Required.';
                        }
                        else if (!RegExp('^[a-zA-Z0-9.]{4,32}\$').hasMatch(value)) {
                          return "Minimum of 4 charachters";
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
//                                    try {
//                                      futureResponse = await LogInuser(
//                                          userNameController.text,
//                                          passwordController.text);
//                                    } catch (e) {
//                                      setState(() {
//                                        isRequesting = false;
//                                      });
//                                      showSnackBar(
//                                        ('  We can\'t reach the server\n'
//                                            '  please check your internet connection! '),
//                                      );
//                                    }
                                    //Navigator.pop(context);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return WelcomeScreen();
                                      },
                                    ));

//                                    switch (futureResponse.statusCode) {
//                                      case 200:
//                                        setState(() {
//                                          isRequesting = false;
//                                        });
//                                        user = new User();
//                                        showSnackBar("Well Come "+ userNameController.text);
//                                        Timer(Duration(seconds: 2), () async {
//                                          //Navigator.pop(context);
//                                          var body_str = await futureResponse.stream
//                                              .bytesToString();
//                                          dynamic body_json = jsonDecode(body_str);
//
//                                          UserInfo st(){
//                                            return UserInfo(userName: body_json['uname'],
//                                                email: body_json['email']);
//                                          }
//
//                                          Navigator.of(context)
//                                              .push(MaterialPageRoute(
//                                            builder: (context) {
//                                              return WelcomeScreen(userInfo:st());
//                                            },
//                                          ));
//                                          setState(() {
//                                            userNameController.text="";
//                                            passwordController.text="";
//                                          });
//                                        });
//
//                                        break;
//                                      case 400:
//                                        setState(() {
//                                          isRequesting = false;
//                                        });
//                                        var body_str = await futureResponse.stream
//                                            .bytesToString();
//                                        dynamic body_json = jsonDecode(body_str);
//                                        showSnackBar(body_json["message"] +
//                                            "\n"
//                                                "make sure you have enterd the correct"
//                                                " user name and password");
//                                        break;
//                                      default:
//                                        showSnackBar(
//                                            "Something went wrong, try again");
//                                        setState(() {
//                                          isRequesting = false;
//                                        });
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
                    isRequesting
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox(height: 60),
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
                            setState(() {
                              userNameController.text='';
                              passwordController.text='';
                            });
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
    final RegExp nameExp = RegExp(r'^[a-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return 'Please enter only small alphabetical characters.';
    }
    return null;
  }

  Future<http.StreamedResponse> LogInuser(
      String name, String password) async {
    var rl = Uri(scheme: 'http', host: consts.location, path: 'api/auth');

    var req = http.MultipartRequest("POST", rl);
    req.fields.addAll({
      "uname": name,
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
class UserInfo
{
  final String userName;
  final String email;
  UserInfo({this.userName,this.email});
}
