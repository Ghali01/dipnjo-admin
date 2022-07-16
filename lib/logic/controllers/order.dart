import 'dart:convert';

import 'package:admin/logic/models/order.dart';
import 'package:admin/logic/models/orders.dart';
import 'package:admin/logic/providers/orders.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderCubit extends Cubit<OrderState> {
  final int id;
  OrderCubit(this.id) : super(OrderState()) {
    load().then((value) => null);
  }
  Future<void> load() async {
    try {
      String rawData = await OrdersAPI.getOrder(id);
      Map data = jsonDecode(rawData);
      emit(state.copyWith(
          data: data,
          status: OrderStatus.values
              .where((element) => element.code == data['status'])
              .first,
          loaded: true));
    } catch (e) {
      print(e);
    }
  }

  void setNextStatus(OrderStatus status) =>
      emit(state.copyWith(nextStatus: status));
  void save() async {
    try {
      if (state.nextStatus != state.status) {
        emit(state.copyWith(loading: true));
        await OrdersAPI.setStatus(state.nextStatus!.code, id);
        emit(state.copyWith(status: state.nextStatus, loading: false));
      }
    } catch (e) {
      print(e);
    }
  }
}
