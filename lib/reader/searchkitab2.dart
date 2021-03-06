import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kitabui/widgets/book_ratingss.dart';

class KitabBooks2 extends StatefulWidget {
  const KitabBooks2({Key key}) : super(key: key);

  @override
  KitabBooks2State createState() => KitabBooks2State();
}

class KitabBooks2State extends State<KitabBooks2> {

  final scafoldkey= GlobalKey<ScaffoldState>();

  TextEditingController queryController;
  List<KitBook> books = [];
  bool pending = false;
  @override
  void initState() {
    super.initState();
    this.queryController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldkey,
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Kitab Books"),
      ),
      body: Column(
        children: <Widget>[
          Divider(),
          SizedBox(height: 20),
          TextField(
            controller: this.queryController,
            decoration: InputDecoration(
              labelText: 'Search Books With Title',
              labelStyle: TextStyle(
                color: Colors.yellow,
              ),
              border: OutlineInputBorder(),
            ),
          ),

          ButtonBar(
            children: <Widget>[
              RaisedButton(
                color: Colors.green,
                onPressed:
                pending ? null : () => this.search(queryController.text),
                child: Text(
                    'Search'),
              ),

            ],
          ),
          if (this.books.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: this.books.length,
                itemBuilder: (ctx, i) => bookToListTile(books[i]),
              ),
            ),
        ],
      ),


    );
  }

  ListTile bookToListTile(KitBook book) {
    return ListTile(
      tileColor: Colors.lightBlueAccent,
      title: Text(book.title),
      subtitle: Text(book.authors),
      trailing: Hero(tag: book.id, child: book.thumbnail),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MyBookDetailsPage(book)),
      ),
    );
  }

  Future<List<KitBook>> getBooksList(String query) async {
    final uri = Uri(
      scheme: 'https',
      host: 'www.googleapis.com',
      path: 'books/v1/volumes',
      queryParameters: {'q': query},
    );
    print('uri=$uri');
    final http.Response response = await http.get(uri.toString());
    if (response.statusCode == 200) {
      return KitBook.parseFromJsonStr(response.body);
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
// Data class to convert from the json response.
class KitBook {
  final String price;
  final String id;
  final String title;
  final String authors;
  final String description;
  final String thumbnailUrl;
  KitBook(
      this.id,
      this.price,
      this.title,
      this.authors,
      this.description,
      this.thumbnailUrl);

  Widget get thumbnail => this.thumbnailUrl != null
      ? Image.network(this.thumbnailUrl)
      : CircleAvatar(child: Text(this.title[0]));

  KitBook.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'] as String,
        price=jsonMap['volumeInfo']['price'] as String,
        title = jsonMap['volumeInfo']['title'] as String,
        authors = (jsonMap['volumeInfo']['authors'] as List).join(', '),
        description = jsonMap['volumeInfo']['description'] as String ??
            '<missing description>',
        thumbnailUrl =
        jsonMap['volumeInfo']['imageLinks']['smallThumbnail'] as String;

  static List<KitBook> parseFromJsonStr(String jsonStr) {
    final jsonMap = jsonDecode(jsonStr);
    final jsonList = jsonMap['items'] as List<dynamic>;
    print('${jsonList.length} items in json');
    return [
      for (final jsonMap in jsonList)
        KitBook.fromJson(jsonMap as Map<String, dynamic>)
    ];
  }
}

class MyBookDetailsPage extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final KitBook book;
  const MyBookDetailsPage(this.book);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Hero(
              tag: book.id,
              child: book.thumbnail,
            ),
            SizedBox(height:20.0),
            StatefulStarRating(),
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Text(book.description),
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