import 'dart:convert';
import 'package:http/http.dart' as http;

class Server {
  // static const String host = '127.0.0.1:8000';
  // static const String host = 'ghale02.pythonanywhere.com';
  static const String host = '10.0.2.2:8000';
  static const String protocol = 'http';
  static Future<http.Response> send(Function method, String path,
      {Object? body,
      Map<String, String>? headers,
      bool jsonBody = true,
      bool useToken = true}) async {
    String url = '$protocol://$host/$path';

    if (useToken) {
      String token = 'token';
      headers ??= {};
      headers['Authorization'] = ' Token $token';
    }
    if (method == http.get) {
      String qp = '?';
      if (body is Map) {
        for (var e in body.entries) {
          qp = qp + '${e.key}=${e.value}&';
        }
      }
      return await http.get(
        Uri.parse(url + qp),
        headers: headers,
      );
    } else {
      if (jsonBody) {
        headers ??= {};
        headers['Content-Type'] = 'application/json';
        body = jsonEncode(body);
      }
      return await method(Uri.parse(url), body: body, headers: headers);
    }
  }

  static String getAbsoluteUrl(String sub) => '$protocol://$host$sub';
}
