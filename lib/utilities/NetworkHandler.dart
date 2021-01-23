
import 'package:http/http.dart' as http;

class NetworkHandler {
    static String baserUrl = 'http://192.168.8.106:3000/';
    static var headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
    };

    static Future<http.Response> get(String url) async {
        url = formatter(url);
        var response = await http.get(url);
        return response;
    }

    static Future<http.Response> post(String url, var body) async {
        url = formatter(url);

        final http.Response response = await http.post(
            url,
            headers: headers,
            body: body
        );
        return response;
    }

    static String formatter(String url) {
        return baserUrl + url;
    }

}