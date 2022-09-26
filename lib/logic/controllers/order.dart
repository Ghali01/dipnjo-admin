import 'dart:convert';

import 'package:admin/logic/models/order.dart';
import 'package:admin/logic/models/orders.dart';
import 'package:admin/logic/providers/orders.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

class OrderCubit extends Cubit<OrderState> {
  final int id;
  OrderCubit(this.id) : super(OrderState()) {
    load().then((value) => null);
  }
  Future<void> load() async {
    try {
      String rawData = await OrdersAPI.getOrder(id);
      Map data = jsonDecode(rawData);
      data['fee'] = calculateDistance(double.parse(data['location']['lat']),
              double.parse(data['location']['lng']))
          .toInt()
          .toStringAsFixed(1);
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

  double calculateDistance(lat1, lon1) {
    // 32.539136552913256, 35.87706417036341 pr.husin jordon
// 33.51168665532067, 36.296951275345315 damascus
    // 33.43347967066062, 36.255868127463536 shnaya
    var lat2 = 33.51168665532067;
    var lon2 = 36.296951275345315;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return (12742 * asin(sqrt(a)));
  }
}
