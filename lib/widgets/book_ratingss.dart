import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../consts.dart' as consts;

class StarRating extends StatelessWidget {
    final void Function(int index) onChanged;
    final int value;
    final IconData filledStar;
    final IconData unfilledStar;

    const StarRating({
        Key key,
        @required this.onChanged,
        this.value = 0,
        this.filledStar,
        this.unfilledStar,
    })  : assert(value != null),
            super(key: key);
    @override
    Widget build(BuildContext context) {
        final color = Colors.yellow;
        final size = 36.0;
        return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
                return IconButton(
                    onPressed: onChanged != null
                        ? () {
                        onChanged(value == index + 1 ? index : index + 1);
                    }
                        : null,
                    color: index < value ? color : null,
                    iconSize: size,
                    icon: Icon(
                        index < value ? filledStar ?? Icons.star : unfilledStar ?? Icons.star_border,
                    ),
                    padding: EdgeInsets.zero,
                    tooltip: "${index + 1} of 5",
                );
            }),
        );
    }
}
class StatefulStarRating extends StarRating {
    @override
    Widget build(BuildContext context) {
        int rating = 0;
        return StatefulBuilder(
            builder: (context, setState) {
                return StarRating(
                    onChanged: (index) {
                        setState(() {
                            rating = index;
                        });
                    },
                    value: rating,
                );
            },
        );
    }
}

Future<http.StreamedResponse> rating(String rate) async {
    var rl = Uri(scheme: 'http', host: consts.location, path: 'api/rating');

    var req = http.MultipartRequest("POST", rl);
    req.fields.addAll({
        "Rating": rate,

    });

    var response = await req.send();

//    print("I got " + await response.stream.bytesToString());
    return response;
}
