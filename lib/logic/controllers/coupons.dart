import 'dart:convert';

import 'package:admin/logic/models/coupons.dart';
import 'package:admin/logic/providers/orders.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CouponsCubit extends Cubit<CouponsState> {
  CouponsCubit() : super(CouponsState()) {
    load().then((value) => null);
  }

  Future<void> load() async {
    try {
      emit(state.copyWith(loading: true));
      List r = await OrdersAPI.getCoupons(state.page, state.search);
      if (r[1] == state.search) {
        var data = jsonDecode(r[0]);
        List items = [...(state.coupons), ...data];
        emit(state.copyWith(
          loaded: true,
          loading: false,
          page: state.page + 1,
          noMore: data.length < 25,
          coupons: items,
        ));
      }
    } catch (e) {}
  }

  void setTextSearch(String text) {
    if (text == state.search) return;
    emit(state.copyWith(search: text, coupons: [], noMore: false, page: 1));
    load().then((value) => null);
  }

  void setStatus(int id, bool value) async {
    try {
      List items = state.coupons.toList();
      int index = items.indexWhere((element) => element['id'] == id);
      items[index]['loading'] = true;
      emit(state.copyWith(coupons: items));
      await OrdersAPI.setCouponStatus(id, value);
      items[index]['loading'] = false;
      items[index]['enabled'] = value;
      items = items.toList();
      emit(state.copyWith(coupons: items));
    } catch (e) {}
  }

  void add(Map item) {
    List items = state.coupons.toList();
    items.insert(0, item);
    emit(state.copyWith(coupons: items));
  }
}
