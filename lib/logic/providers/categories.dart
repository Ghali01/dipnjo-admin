import 'dart:convert';

import 'package:admin/utilities/server.dart';
import 'package:http/http.dart' as http;

class CategoryAPI {
  static Future<String> get() async {
    http.Response response = await Server.send(http.get, 'foods/category');
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception();
  }

  static Future<String> post(String name) async {
    http.Response response = await Server.send(
      http.post,
      'foods/category',
      body: {
        'name': name,
      },
    );
    if (response.statusCode == 201) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception();
  }

  static Future<void> put(String name, int id) async {
    http.Response response = await Server.send(
      http.put,
      'foods/category/$id',
      body: {"name": name},
    );
    if (response.statusCode == 200) {
      return;
    }
    throw Exception();
  }
}
