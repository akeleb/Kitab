import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kitabui/screens/download.dart';
import 'package:kitabui/widgets/book_ratingss.dart';

final uri = Uri(
    scheme: 'https',
    host: 'www.googleapis.com',
    path: 'books/v1/volumes',
    queryParameters: {'q': "Abel"},);

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Books in our store'),
        //leading: Icon(Icons.book_online),
      ),
      body: FutureBuilder(
          future: fetchPotterBooks(),
          builder: (context, AsyncSnapshot<List<KitBook>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: unable to reach the server'));
              } else {
                return ListView(
                    children: snapshot.data.map((b) => BookTile(b)).toList());
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class BookTile extends StatelessWidget {
  final KitBook book;
  BookTile(this.book);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        tileColor: Colors.blueGrey,
      trailing: book.thumbnail,
      title: Text(book.title),
      subtitle: Text(book.author),
      onTap: () => navigateToDetailsPage(book, context),
    );
  }
}

Future<List<KitBook>> fetchPotterBooks() async {
  final res = await http.get(uri);
  if (res.statusCode == 200) {
    return parseBookJson(res.body);
  } else {
    throw Exception('Error: ${res.statusCode}');
  }
}

List<KitBook> parseBookJson(String jsonStr) {
  final jsonMap = json.decode(jsonStr);
  final jsonList = (jsonMap['items'] as List<dynamic>);
  return jsonList.map((jsonBook) => KitBook(
    id: jsonBook['volumeInfo']['id'],
    title: jsonBook['volumeInfo']['title'],
    description: jsonBook['volumeInfo']['description']as String ??
        '<missing description>',
    author: (jsonBook['volumeInfo']['authors'] as List).join(', '),
    thumbnailUrl: jsonBook['volumeInfo']['imageLinks']
    ['smallThumbnail'],
  ))
      .toList();
}

class KitBook {
  final String id;
  final String title;
  final String author;
  final String description;
  final String thumbnailUrl;

  KitBook({ this.id,
    this.title,
    this.author,
    this.description,
    this.thumbnailUrl})
      : assert(title != null),
        assert(author != null);
  Widget get thumbnail => this.thumbnailUrl != null
      ? Image.network(this.thumbnailUrl)
      : CircleAvatar(child: Text(this.title[0]));
}

void navigateToDetailsPage(KitBook book, BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => BookDetailsPage(book),
  ));
}

class BookDetailsPage extends StatelessWidget {
  final KitBook book;
  BookDetailsPage(this.book);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: BookDetails(book),
      ),
    );
  }
}

class BookDetails extends StatelessWidget {
  final KitBook book;
  BookDetails(this.book);
  //StatefulStarRating star;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(book.title),
          Image.network(book.thumbnailUrl),
          SizedBox(height: 10.0),
          StatefulStarRating(),
          //Text(star.value.toString()),
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
              onPressed: () =>  Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => Kdownload()),
              ),

            ),
          ),
        ],
      ),
    );
  }
}