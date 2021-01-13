import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
        leading: Icon(Icons.book),
      ),
      body: FutureBuilder(
          future: fetchPotterBooks(),
          builder: (context, AsyncSnapshot<List<KitBook>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
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
  final String thumbnailUrl;

  KitBook({ this.id,
    this.title,
    this.author,
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
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BookDetails(book),
      ),
    );
  }
}

class BookDetails extends StatelessWidget {
  final KitBook book;
  BookDetails(this.book);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(book.thumbnailUrl),
          SizedBox(height: 10.0),
          Text(book.title),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(book.author,
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}