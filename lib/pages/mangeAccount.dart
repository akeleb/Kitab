import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kitabui/models/User.dart';

import 'login_screen.dart';

final rl = Uri(scheme: 'http', host: '192.168.43.19', path: 'api/userInfo');

class ManageAccount extends StatefulWidget {
  const ManageAccount({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ManageAccountState();
}

class ManageAccountState extends State<ManageAccount> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      appBar: AppBar(title: Text("Account Management")),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 75.0),
        width: double.infinity,
        child: Center(
          child: Column(
            children: <Widget>[
              Text("What do you want to do with your account?",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              Form(
                child: RaisedButton(
                  elevation: 5,
                  child: Text("Update profile",
                    style: TextStyle(
                      color: Colors.indigo,
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),),
                    onPressed:() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context)  {
                            return  UserField();
                          },
                        ),
                      );
                    },
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  color: Colors.greenAccent,
                ),
              ),
              SizedBox(height: 40),
              Form(
                child: RaisedButton(
                  elevation: 5,
                    onPressed: (){},
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  color: Colors.greenAccent,
                  child: Text("Deactivate Account",
                    style: TextStyle(
                      color: Colors.indigo,
                      letterSpacing: 1.5,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),),


                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserField extends StatefulWidget  {
  @override
  _UserFieldState createState() => _UserFieldState();
}
class _UserFieldState extends State<UserField> {
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

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  http.StreamedResponse futureResponse;

  bool showPassword = true;
  String name;
  String phoneNumber;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: FutureBuilder(
          future: fetchUserInfo(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('  We can\'t reach the server\n'
                    '  please check your internet connection! ',
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'OpenSans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ));
              }
              else {
                return Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 50.0, horizontal: 16.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(height: 60.0),
                          // "Name" form.
                          TextFormField(
                            initialValue: user.name,
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
                            initialValue: user.phoneNumber,
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
                            initialValue: user.email,
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

                          SizedBox(height: 24.0),
                          // "Password" form.
                          TextFormField(
                            initialValue: user.password,
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
                                color:
                                    showPassword ? Colors.blueGrey : Colors.red,
                              ),
                            ),
                            validator: (String value) {
                              if (!RegExp('^[a-zA-Z0-9.]{4,32}\$')
                                  .hasMatch(value)) {
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
                                    try {
                                      futureResponse = await RegUser(
                                          userNameController.text,
                                          phoneNumberController.text,
                                          emailController.text,
                                          passwordController.text);
                                    } catch (e) {
                                      showSnackBar(
                                        ('Error: $e'),
                                      );
                                    }
                                    switch (futureResponse.statusCode) {
                                      case 200:
                                        user = new User();
                                        showSnackBar(
                                            "Well Come $userNameController");
                                        Timer(Duration(seconds: 5), () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) {
                                              return LoginPage();
                                            },
                                          ));
                                        });

                                        break;
                                      case 400:
                                        var body_str = await futureResponse
                                            .stream
                                            .bytesToString();
                                        dynamic body_json =
                                            jsonDecode(body_str);
                                        showSnackBar("message: " +
                                            body_json["message"] +
                                            "\n"
                                                "attribute: " +
                                            body_json["attribute"] +
                                            "\n"
                                                "error: " +
                                            body_json["error"]);
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
                                  'Update',
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
                        ],
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  // ignore: missing_return
   fetchUserInfo() async {
    final res = await http.get(rl);
    if (res.statusCode == 200) {
      user = jsonDecode(res.body);

    } else {
      throw Exception('Error: ${res.statusCode}');
    }
  }

  Future<http.StreamedResponse> RegUser(
      String name, String phoneNumber, String email, String password) async {
    var rl = Uri(scheme: 'http', host: '192.168.43.19', path: 'api/register');

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

