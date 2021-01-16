import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitabui/screens/details_screen.dart';
import 'package:kitabui/widgets/reading_card_list.dart';
class Books extends StatelessWidget {
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Well Come to Kitab"),
      ),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.tealAccent,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: size.height * .1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: RichText(
                      text: TextSpan(
                        // ignore: deprecated_member_use
                        style: Theme.of(context).textTheme.display1,
                        children: [
                          TextSpan(text: "Books in \nour store "),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        ReadingListCard(
                          thumbnailUrl: "assets/images/book-1.jpg",
                          title: "ብርቅርቅታ",
                          authors: "ዳንኤል ስቲል",
                          rating: 4.9,
                          pressDetails: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DetailsScreen();
                                },
                              ),
                            );
                          },
                        ),
                        ReadingListCard(
                          thumbnailUrl: "assets/images/book-2.jpg",
                          title: "ከአድማስ ባሻገር",
                          authors: "በአሉ ግርማ",
                          rating: 4.8,
                        ),
                        SizedBox(width: 30),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        ReadingListCard(
                          thumbnailUrl: "assets/images/book-1.jpg",
                          title: "ብርቅርቅታ",
                          authors: "ዳንኤል ስቲል",
                          rating: 4.9,
                          pressDetails: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DetailsScreen();
                                },
                              ),
                            );
                          },
                        ),
                        ReadingListCard(
                          thumbnailUrl: "assets/images/book-2.jpg",
                          title: "ከአድማስ ባሻገር",
                          authors: "በአሉ ግርማ",
                          rating: 4.8,
                        ),
                        SizedBox(width: 30),
                      ],
                    ),
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        ReadingListCard(
                          thumbnailUrl: "assets/images/book-1.jpg",
                          title: "ብርቅርቅታ",
                          authors: "ዳንኤል ስቲል",
                          rating: 4.9,
                          pressDetails: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DetailsScreen();
                                },
                              ),
                            );
                          },
                        ),
                        ReadingListCard(
                          thumbnailUrl: "assets/images/book-2.jpg",
                          title: "ከአድማስ ባሻገር",
                          authors: "በአሉ ግርማ",
                          rating: 4.8,
                        ),
                        SizedBox(width: 30),
                      ],
                    ),
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        ReadingListCard(
                          thumbnailUrl: "assets/images/book-1.jpg",
                          title: "ብርቅርቅታ",
                          authors: "ዳንኤል ስቲል",
                          rating: 4.9,
                          pressDetails: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DetailsScreen();
                                },
                              ),
                            );
                          },
                        ),
                        ReadingListCard(
                          thumbnailUrl: "assets/images/book-2.jpg",
                          title: "ከአድማስ ባሻገር",
                          authors: "በአሉ ግርማ",
                          rating: 4.8,
                        ),
                        SizedBox(width: 30),
                      ],
                    ),
                  ),


                ]),
          )
        ]
            )

        ));
  }
}
