import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  const Category({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CategoryState();
}

class CategoryState extends State<Category> {
  static const menuItems = <String>[
    'Fictional Books',
    'History Books',
    'Translated Books',
    'Religious Books',
    'Psychology Books',
    'Philosophy Books',
    'Educational Boooks',
    'Poletical Books',
    'Diary Books'
  ];
  final List<DropdownMenuItem<String>> CategoryItems = menuItems
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();
  final List<PopupMenuItem<String>> popUpMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  String btnSelectedVal;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
        appBar: AppBar(title: Text("Category")),
        body:Column(
      children: <Widget>[
        ListTile(
          title: const Text('Choose your book category'),
          trailing: DropdownButton(
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
      ],
    ),);

  }
}
