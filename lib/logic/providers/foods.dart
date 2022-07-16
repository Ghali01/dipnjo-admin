import 'dart:convert';

import 'package:admin/utilities/server.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;

class FoodsAPI {
  static Future<String> getCategoryFoods(int category, int page) async {
    http.Response response =
        await Server.send(http.get, 'foods/category-food/$category/$page');
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception();
  }

  static Future<void> post(String name, int category, String desc, double price,
      String image, List additions, String points) async {
    dio.Dio dioO = dio.Dio();

    dio.Response response =
        await dioO.post(Server.getAbsoluteUrl('/foods/food'),
            data: dio.FormData.fromMap({
              'name': name,
              'desc': desc,
              'price': price,
              'points': points.isNotEmpty ? int.parse(points) : null,
              'category': category,
              'image': await dio.MultipartFile.fromFile(image),
            }));
    print(response.data);
    if (response.statusCode == 201) {
      List addtionsP = [];
      for (Map e in additions) {
        addtionsP.add({
          "food": response.data['id'],
          'name': e['name'],
          'price': e['price']
        });
      }
      http.Response responseA = await Server.send(
          http.post, 'foods/add-addition-food',
          body: {'additions': addtionsP});
      if (responseA.statusCode == 201) {
        return;
      }
    } else {}
    throw Exception();
  }

  static Future<String> getFoodById(int id) async {
    http.Response response = await Server.send(http.get, 'foods/food/$id');
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception();
  }

  static Future<void> updateFood(int id, int category, String name, String desc,
      double price, String points, String? image) async {
    var data = {
      "name": name,
      'desc': desc,
      'category': category,
      'price': price,
      'points': points.isNotEmpty ? int.parse(points) : null,
    };
    if (image != null) {
      data['image'] = await dio.MultipartFile.fromFile(image);
    }
    dio.Dio dioO = dio.Dio();
    dio.Response response = await dioO.put(
      Server.getAbsoluteUrl('/foods/food/$id'),
      data: dio.FormData.fromMap(data),
    );
    if (response.statusCode == 200) {
      return;
    }
    throw Exception();
  }

  static Future<int> saveAddition(String name, double price, int food) async {
    http.Response response = await Server.send(http.post, 'foods/add-addition',
        body: {'name': name, 'price': price, 'food': food});
    if (response.statusCode == 201) {
      return jsonDecode(utf8.decode(response.bodyBytes))['id'];
    }
    throw Exception();
  }

  static Future<void> deleteAddition(int id) async {
    http.Response response =
        await Server.send(http.delete, 'foods/delete-addition/$id');
    if (response.statusCode == 204) {
      return;
    }
    throw Exception();
  }

  static Future<String> setOffer(
      int food, String type, double value, String end) async {
    http.Response response = await Server.send(http.post, 'foods/add-offer',
        body: {'food': food, 'type': type, 'value': value, 'end': end});
    // print(response.body);
    if (response.statusCode == 201) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception();
  }

  static Future<void> setCategoryVisiblity(int id, bool value) async {
    http.Response response = await Server.send(
        http.put, 'foods/category-visiblity/$id',
        body: {'value': value});
    if (response.statusCode == 200) {
      return;
    }
    throw Exception();
  }

  static Future<void> setFoodVisiblity(int id, bool value) async {
    http.Response response = await Server.send(
        http.put, 'foods/food-visiblity/$id',
        body: {'value': value});
    if (response.statusCode == 200) {
      return;
    }
    throw Exception();
  }

  static Future<String> getAds() async {
    http.Response response =
        await Server.send(http.get, 'foods/advertise-admin');
    print(response.body);
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }

    throw Exception();
  }

  static Future<void> deleteAd(int id) async {
    http.Response response =
        await Server.send(http.delete, 'foods/advertise-admin/$id');
    if (response.statusCode == 204) {
      return;
    }
    throw Exception();
  }

  static Future<String> addAd(
      String title, String subtitle, int food, String image) async {
    dio.Dio dioO = dio.Dio();
    dio.Response response = await dioO.post(
      Server.getAbsoluteUrl('/foods/advertise-admin'),
      data: dio.FormData.fromMap({
        "title": title,
        "subTitle": subtitle,
        'food': food,
        'image': await dio.MultipartFile.fromFile(image),
      }),
    );
    if (response.statusCode == 201) {
      return response.toString();
    }
    throw Exception();
  }

  static Future<String> getAllFoods() async {
    http.Response response = await Server.send(http.get, 'foods/all');

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }

    throw Exception();
  }
}
