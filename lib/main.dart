import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:kitabui/utilities/consttants.dart';
import 'package:flutter/material.dart';
import 'package:kitabui/pages/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyAppState createState()=>MyAppState();
}
class MyAppState extends State<MyApp>{

  bool isSecureScreen=false;
  // This widget is the root of your application.
  @override
  // ignore: must_call_super
  initState(){
    secureScreen();
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kitab',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(
              displayColor: kBlackColor,
            ),
      ),
      home: LoginPage(),
    );
  }
  Future<void>secureScreen()async{
    if(isSecureScreen=true){
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
    else{
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    }
    setState((){
      isSecureScreen=!isSecureScreen;

    });
  }
}

