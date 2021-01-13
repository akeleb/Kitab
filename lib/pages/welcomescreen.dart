import 'package:flutter/material.dart';
import 'package:kitabui/reader/category.dart';
import 'package:kitabui/reader/listbooks.dart';
import 'package:kitabui/reader/books.dart';
import 'package:kitabui/screens/home_screen.dart';
import 'package:kitabui/reader/searchkitab.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const drawerHeader = UserAccountsDrawerHeader(
      accountName: Text('Akele'),
      accountEmail: Text('akele@kitab.com'),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage("assets/images/ab.png"),
        backgroundColor: Colors.white,

        //child: FlutterLogo(size: 42.0),
      ),

    );
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
          title: Text('Home'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return HomeScreen();
                },
              ),
            );
          },
        ),
        ListTile(
            tileColor: Colors.blueGrey,
          title: Text('Books'),
          onTap: () =>  Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => BookListPage()),
          ),
        ),
        ListTile(
          title: Text('Category'),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Category();
                },
              ),
            );
          }
        ),
        ListTile(
          title: Text('New Release'),
          onTap: (){}
        ),
        ListTile(
            title: Text('Search'),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return KitabBooks();
                  },
                ),
              );
            }
        ),
        ListTile(
            title: Text('Mange Account'),
            onTap: (){}
        ),

      ],
    );
    return Scaffold(
      backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Colors. blueAccent,
          title:  Text('Kateb Ethiopian eBook Store'),
        ),
        body:  HomeScreen(),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.blueGrey,
          ),
          child: Drawer(
            child: drawerItems,
          ),
        )
    );
  }
}

// <void> means this route returns nothing.
class NewPage extends MaterialPageRoute<void> {
  NewPage(String id)
      : super(builder: (BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(' $id'),
        elevation: 1.0,
      ),
      body: Center(
        child: Text(' $id'),
      ),
    );
  });
}