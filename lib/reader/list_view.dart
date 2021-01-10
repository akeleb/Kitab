
import 'package:flutter/material.dart';
import 'package:kitabui/widgets/reading_card_list.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kitabui/widgets/book_ratingss.dart';


class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final scafoldkey= GlobalKey<ScaffoldState>();
  final String query= "Akele";
  List<MyBook> books = [];
  bool pending = false;
  @override
  void initState() {
    super.initState();
  }
  MyBook b;
  @override
  Widget build(BuildContext context) {

    var listView = new ListView.builder(
      itemCount: this.books.length,
      itemBuilder: (BuildContext context, int index) {
        search(query);
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              ReadingListCard(
                thumbnailUrl: b.thumbnailUrl,
                title: b.title,
                authors: b.authors,
                rating: 4.9,
                pressDetails: () {},
              ),
              SizedBox(width: 30),
            ],
          ),
        );
      },
    );
    return new Scaffold(
      key: scafoldkey,
      backgroundColor: Colors.tealAccent,
      appBar: new AppBar(
        title: new Text("Books in our store",
          style: TextStyle(
            fontSize: 30,
            color: Colors.black
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 60),
        child: listView,
      ),

    );
  }

  Future<List<MyBook>> getBooksList(String query) async {
    final uri = Uri(
      scheme: 'https',
      host: 'www.googleapis.com',
      path: 'books/v1/volumes',
      queryParameters: {'q': query},
    );
    print('uri=$uri');
    final http.Response response = await http.get(uri.toString());
    if (response.statusCode == 200) {
      return MyBook.parseFromJsonStr(response.body);
    } else {
      throw response;
    }
  }

  Future<void> search(String query) async {
    setState(() => this.pending = true);
    try {
      this.books = await getBooksList(query);
      scafoldkey.currentState.showSnackBar(
        SnackBar(content: Text('Successfully found ${books.length} books.')),
      );
    } catch (e) {
      scafoldkey.currentState.showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    setState(() => this.pending = false);
  }

}
 class MyBook {
  final String price;
  final String id;
  final String title;
  final String authors;
  final String description;
  final  String thumbnailUrl;
  MyBook(
      this.id,
      this.price,
      this.title,
      this.authors,
      this.description,
      this.thumbnailUrl);

   Widget get thumbnail => thumbnailUrl != null
      ? Image.network(this.thumbnailUrl)
      : CircleAvatar(child: Text(this.title[0]));

  MyBook.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'] as String,
        price=jsonMap['volumeInfo']['price'] as String,
        title = jsonMap['volumeInfo']['title'] as String,
        authors = (jsonMap['volumeInfo']['authors'] as List).join(', '),
        description = jsonMap['volumeInfo']['description'] as String ??
            '<missing description>',
        thumbnailUrl =
        jsonMap['volumeInfo']['imageLinks']['smallThumbnail'] as String;

  static List<MyBook> parseFromJsonStr(String jsonStr) {
    final json = jsonDecode(jsonStr);
    final jsonList = json['items'] as List<dynamic>;
    print('${jsonList.length} items in json');
    return [
      for (final jsonMap in jsonList)
        MyBook.fromJson(jsonMap as Map<String, dynamic>)
    ];
  }
}

