import 'package:flutter/material.dart';
import 'package:kitabui/widgets/book_ratingss.dart';
import 'package:kitabui/screens/home_screen.dart';
class DetailsPage extends StatelessWidget {


Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.blueGrey,
    appBar: AppBar(
      title: Text("ብርቅርቅታ"),
    ),
    body: Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Divider(),
          Row(
            children: [
              Image.asset("assets/images/book-1.jpg"),
             Column(
              children:[ Text(
                 "The Book Title\nHere",
                 style: TextStyle(
                   fontSize: 25,
                 ),
               ),
                Text("Price: 100 Birr",
                    style: TextStyle(
                      color: Colors.green,
                    )
                ),
              ]
             ),

            ],
          ),
          SizedBox(height:20.0),
          StatefulStarRating(),
          Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Text("ሁልጊዜም ቢሆን ትክክለኛውን ነገር እያደረክ መሆኑን አስታውል"
                  "\nአንድን ነገር ሁሉም ሰው እያደረገው ነው ማለት ለድርጊቱ ትክክለኛነት"
                  "ማረጋገጫ ሊሆን አይችልም"),
            ),
          ),

          Container(
            child: RaisedButton(
              elevation: 20,
              color: Colors.blue,
              child:Text("Buy",
                style: TextStyle(
                    color: Colors.red
                ),),
            ),

          ),

        ],
      ),
    ),
  );
}}