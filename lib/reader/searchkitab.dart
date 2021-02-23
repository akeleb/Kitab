import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kitabui/screens/download.dart';
import 'package:kitabui/widgets/book_ratingss.dart';
import '../consts.dart' as consts;

class KitabBooks extends StatefulWidget {
  final String title;

  const KitabBooks({Key key, this.title}) : super(key: key);

  @override
  KitabBooksState createState() => KitabBooksState();
}

class KitabBooksState extends State<KitabBooks> {
  final scafoldkey = GlobalKey<ScaffoldState>();
  http.Response respo;

  TextEditingController queryController;
  List<KitBooks> books = [];
  bool pending = false;
  var isRequesting = false;
  @override
  void initState() {
    super.initState();
    this.queryController = TextEditingController();
    if(widget.title!=null) this.search(widget.title);
  }
  dispose();
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
          widget.title==null? Column(
            children: [
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
                        pending ? null : () => this.search(widget.title!=null? widget.title: queryController.text),
                    child: Text('Search'),
                  ),
                ],
              ),
            ],
          ): SizedBox.shrink(),
          if (this.books.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: this.books.length,
                itemBuilder: (ctx, i) => bookToListTile(books[i]),
              ),
            ),
          isRequesting
              ? Center(child: CircularProgressIndicator())
              : SizedBox(height: 60),
        ],
      ),
    );
  }

  ListTile bookToListTile(KitBooks book) {
    return ListTile(
      tileColor: Colors.blueGrey,
      title: Text(book.title),
      subtitle: Text(book.author),
      trailing: Hero(tag: book.id,
          child: Image.network("http://"+consts.location+"/tmbnl/"+book.id.toString()+".png")),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MyBookDetailsPage(book)),
      ),
    );
  }

  Future<http.StreamedResponse> getBooksList(String title) async {
    var rl = Uri(
        scheme: 'http',
        host: consts.location,
        path: 'api/content/search');

    var req = http.MultipartRequest("POST", rl);

    req.fields.addAll({
      "title": title,
    });

//    print("I got " + await response.stream.bytesToString());
    var response = await req.send();
    return response;
  }

  List<KitBooks> parseFromJsonStr(dynamic jsonStr) {
//  final jsonMap = jsonDecode(jsonStr);
    final jsonList = jsonStr as List<dynamic>;
    print('${jsonList.length} items in json');
    return jsonList.map((e) => KitBooks.fromJson(e)).toList();
  }

  Future<void> search(String title) async {
    setState(() => this.pending = true);
    try {
      setState(() {
        isRequesting = true;
      });
      var x = await getBooksList(title);
      this.books = parseFromJsonStr(json.decode(await x.stream.bytesToString()));
      scafoldkey.currentState.showSnackBar(
        SnackBar(content: Text('Successfully found ${books.length} books.')),
      );
      setState(() {
        isRequesting = false;
      });
    } catch (e) {
      scafoldkey.currentState.showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() {
        isRequesting = false;
      });
    }
    setState(() => this.pending = false);
  }
}

// Data class to convert from the json response.
List<KitBooks> parseFromJsonStr(dynamic jsonStr) {
//  final jsonMap = jsonDecode(jsonStr);
  final jsonList = jsonStr as List<dynamic>;
  print('${jsonList.length} items in json');
  return jsonList.map((e) => KitBooks.fromJson(e)).toList();
}
class KitBooks {
  final String price;
  final int id;
  final String title;
  final String author;
  final String description;
//  final String thumbnailUrl;

  KitBooks(
    this.id,
    this.price,
    this.title,
    this.author,
    this.description, 
  );
  KitBooks.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'] as int,
        price = jsonMap['price'].toString(),
        title = jsonMap['title'] as String,
        author = jsonMap['author'] as String,
        description =
            jsonMap['description'] as String ?? '<missing description>';
}

class MyBookDetailsPage extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final KitBooks book;
  const MyBookDetailsPage(this.book);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(4),
        child: Column(
          children: [
//
            SizedBox(height: 20.0),
            Hero(tag: book.id,
                child: Image.network(
                    "http://"+consts.location+"/tmbnl/"+book.id.toString()+".png")),
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
                child: Text(
                  "Read",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => Kdownload(this.book)),
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
