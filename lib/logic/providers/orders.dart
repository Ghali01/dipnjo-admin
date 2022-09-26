import 'dart:convert';
import 'package:admin/utilities/server.dart';
import 'package:http/http.dart' as http;

class OrdersAPI {
  static Future<String> getOrders(int page, Map<String, String?> filter) async {
    filter.removeWhere((key, value) => value == null);
    http.Response response =
        await Server.send(http.get, 'orders/orders/$page', body: filter);
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception();
  }

  static Future<String> getOrder(int id) async {
    http.Response response = await Server.send(http.get, 'orders/order/$id');
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception();
  }

  static Future<void> setStatus(String status, int id) async {
    http.Response response =
        await Server.send(http.put, 'orders/set-order-status', body: {
      'id': id,
      'status': status,
    });
    if (response.statusCode == 200) {
      return;
    }

    throw Exception();
  }

  static Future<String> getProfileOrders(int id, int page) async {
    http.Response response =
        await Server.send(http.get, 'orders/orders-profile/$id/$page');
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception();
  }

  static Future<List<String>> getCoupons(int page, String search) async {
    http.Response response = await Server.send(http.get, 'orders/coupons/$page',
        body: {"key": search});
    if (response.statusCode == 200) {
      return [utf8.decode(response.bodyBytes), search];
    }
    throw Exception();
  }

  static Future<String> addCoupon(String key, String type, int value) async {
    http.Response response =
        await Server.send(http.post, 'orders/coupon', body: {
      "key": key,
      "type": type,
      "value": value,
    });
    if (response.statusCode == 201) {
      return utf8.decode(response.bodyBytes);
    } else if (response.statusCode == 400) {
      throw CouponEx();
    }
    throw Exception();
  }

  static Future<void> setCouponStatus(int id, bool status) async {
    http.Response response = await Server.send(http.put, 'orders/coupon/$id',
        body: {'value': status});
    if (response.statusCode == 200) {
      return;
    }
    throw Exception();
  }
}

class CouponEx implements Exception {}
