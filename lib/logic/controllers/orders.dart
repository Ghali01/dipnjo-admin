import 'dart:convert';

import 'package:admin/logic/models/orders.dart';
import 'package:admin/logic/providers/orders.dart';
import 'package:admin/main.dart';
import 'package:admin/utilities/notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersState()) {
    load().then((value) => null);

    fbMessages.listen((msg) {
      if (msg.data['type'] == NotificationTypes.newOrder) {
        getNewOrder(int.parse(msg.data['id'])).then((value) => null);
      }
    });
  }

  Future<void> load() async {
    try {
      emit(state.copyWith(loading: true));
      String rawData = await OrdersAPI.getOrders(state.page, {
        "status": state.filterStatus,
        'payMethod': state.filterMethod,
      });
      List data = jsonDecode(rawData);
      for (var element in data) {
        element['loading'] = false;
      }
      List items = [...data, ...(state.orders)];
      emit(state.copyWith(
        loading: false,
        loaded: true,
        page: state.page + 1,
        orders: items,
        noMore: data.length < 20,
      ));
    } catch (e) {}
  }

  void setStatus(String? status) {
    clear({'status': status});
    load().then((value) => null);
  }

  void setMethod(String? method) {
    clear({'method': method});
    load().then((value) => null);
  }

  void clear(Map<String, dynamic> data) => emit(OrdersState(
        loaded: true,
        filterMethod:
            data.containsKey('method') ? data['method'] : state.filterMethod,
        filterStatus:
            data.containsKey('status') ? data['status'] : state.filterStatus,
      ));
  void setItemStatus(String status, int id) async {
    try {
      List items = state.orders.toList();
      int index = items.indexWhere((element) => element['id'] == id);
      items[index]['loading'] = true;
      emit(state.copyWith(orders: items));
      await OrdersAPI.setStatus(status, id);
      items = items.toList();
      items[index]['loading'] = false;
      items[index]['status'] = status;
      emit(state.copyWith(orders: items));
    } catch (e) {}
  }

  Future<void> getNewOrder(int id) async {
    try {
      String rawData = await OrdersAPI.getOrder(id);
      var data = jsonDecode(rawData);
      List items = state.orders.toList();
      items.insert(0, data);
      emit(state.copyWith(orders: items));
    } catch (e) {}
  }

  void reload() async {
    clear({});
    emit(state.copyWith(reloading: true));
    await load();
    emit(state.copyWith(reloading: false));
  }
}
