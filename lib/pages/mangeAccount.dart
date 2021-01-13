import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageAccount extends StatefulWidget {
  const ManageAccount({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ManageAccountState();
}

class ManageAccountState extends State<ManageAccount> {

  final scafoldkey= GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

  }
  static const menuItems = <String>[
    'Edit Your Profile',
    'Delete Your Account',
  ];
  final List<DropdownMenuItem<String>> CategoryItems = menuItems
      .map(
        (String value) => DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    ),
  )
      .toList();

  String btnSelectedVal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldkey,
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(title: Text("Account Management")),
      body:Column(

        children: <Widget>[
            ListTile(
              title: const Text('What do you want to do with your account?'

              ),
              trailing: DropdownButton(
                dropdownColor: Colors.blueGrey,
                value: btnSelectedVal,
                hint: const Text('Choose'),
                onChanged: (String newValue) {
                  setState(() {
                    btnSelectedVal = newValue;
                  });
                },
                items: CategoryItems,
              ),
            ),
          ButtonBar(
            children: <Widget>[
              RaisedButton(
                color: Colors.green,
                child: Text('Choose'),

                onPressed:(){

                },
              ),
            ],
          ),
        ],
      ),);
  }



  }






