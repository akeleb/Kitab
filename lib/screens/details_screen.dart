
import 'package:kitabui/widgets/book_rating.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
    final String description ="If you learn life's lessons you will do well"
        "If not life will just Continue to push you around, "
        "who controls the past controls the future, who controls "
        "the present controls the past.";
    @override
    Widget build(BuildContext context) {
        var size = MediaQuery.of(context).size;
        return Scaffold(
            backgroundColor: Colors.blueGrey,
            body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                                Container(
                                    alignment: Alignment.topCenter,
                                    padding: EdgeInsets.only(
                                        top: size.height * .12,
                                        left: size.width * .1,
                                        right: size.width * .02),
                                    height: size.height * .48,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(50),
                                            bottomRight: Radius.circular(50),
                                        ),
                                    ),
                                    child: BookInfo(
                                        size: size,
                                    )),
                            ],
                        ),
                        Text("    $description"),
                        SizedBox(
                            height: 40,
                        ),
                    ],
                ),
            ),
        );
    }
}


class BookInfo extends StatelessWidget {
    const BookInfo({
        Key key,
        this.size,
    }) : super(key: key);

    final Size size;

    @override
    Widget build(BuildContext context) {
        return Container(
            child: Flex(
                crossAxisAlignment: CrossAxisAlignment.start,
                direction: Axis.horizontal,
                children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Column(
                            children: <Widget>[

                                Container(
                                    margin: EdgeInsets.only(top: this.size.height * .005),
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(top: 0),
                                    child: Text(
                                        "ምስቸገር እና መቸገር",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),
                                Row(
                                    children: <Widget>[
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                                Container(
                                                    width: this.size.width * .3,
                                                    padding:
                                                    EdgeInsets.only(top: this.size.height * .02),
                                                    child: Text(
                                                        "ይህች አለም የጠንካሮች ናት። ለደካሞች ቦታ የላትም። ስለዚህ ከአሁኑ ከየትኛው ወገን መሆንህ መለየት ያስፈልግሀል።",
                                                        maxLines: 5,
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.yellow,
                                                        ),
                                                    ),
                                                ),
                                                Container(
                                                    margin:
                                                    EdgeInsets.only(top: this.size.height * .015),
                                                    padding: EdgeInsets.only(left: 10, right: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(30),
                                                    ),
                                                    child: FlatButton(
                                                        onPressed: () {},
                                                        child: Text(
                                                            "Read",
                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                    ),
                                                )
                                            ],
                                        ),
                                        Column(
                                            children: <Widget>[
                                                IconButton(
                                                    icon: Icon(
                                                        Icons.favorite_border,
                                                        size: 20,
                                                        color: Colors.grey,
                                                    ),
                                                    onPressed: () {},
                                                ),
                                                BookRating(score: 4.9),
                                            ],
                                        )
                                    ],
                                )
                            ],
                        )),
                    Expanded(
                        flex: 1,
                        child: Container(
                            color: Colors.transparent,
                            child: Image.asset(
                                "assets/images/book-1.jpg",
                                height: double.infinity,
                                alignment: Alignment.topRight,
                                fit: BoxFit.fitWidth,
                            ),
                        )),
                ],
            ),
        );
    }
}
