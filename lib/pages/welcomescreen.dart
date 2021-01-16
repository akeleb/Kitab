import 'package:flutter/material.dart';
import 'package:kitabui/pages/demologin.dart';
import 'package:kitabui/reader/category.dart';
import 'package:kitabui/reader/listbooks.dart';
import 'package:kitabui/screens/home_screen.dart';
import 'package:kitabui/reader/searchkitab.dart';

import 'mangeAccount.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const drawerHeader = UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Colors.teal,
        shape: BoxShape.rectangle,

      ),

      accountName: Text('Akele',style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'OpenSans',
      ),),
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
        Divider(
          color: Colors.red,
          height: 1,
          thickness: 5,
          indent: 20,
          endIndent: 20,
        ),
        ListTile(
          title: Text('Home',style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontFamily: 'OpenSans',
          ),),
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
          title: Text('Books',style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),),
          onTap: () =>  Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => BookListPage()),
          ),
        ),
        ListTile(
          title: Text('Category',style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),),
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
          title: Text('New Release',style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),),
          onTap: (){
          }
        ),
        ListTile(
            title: Text('Search',style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),),
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
            title: Text('Mange Account',style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ManageAccount();
                  },
                ),
              );
            }
        ),
        ListTile(
            title: Text('About Us',style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),),
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