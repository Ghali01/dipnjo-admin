import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:admin/utilities/server.dart';

class UsersAPI {
  static Future<List<String>> getUser(int page, String search) async {
    http.Response response = await Server.send(http.get, 'accounts/users/$page',
        body: {'name': search});
    if (response.statusCode == 200) {
      return [utf8.decode(response.bodyBytes), search];
    }

    throw Exception();
  }
}
