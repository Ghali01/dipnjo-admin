import 'dart:convert';

import 'package:admin/logic/models/add_coupon.dart';
import 'package:admin/logic/providers/orders.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCouponCubit extends Cubit<AddCouponState> {
  AddCouponCubit() : super(AddCouponState());

  void save(String key, int value) async {
    try {
      emit(state.copyWith(loading: true));
      String rawData = await OrdersAPI.addCoupon(key, state.type, value);
      var data = jsonDecode(rawData);
      emit(state.copyWith(done: true, loading: false, data: data));
    } on CouponEx catch (e) {
      emit(state.copyWith(loading: false, error: 'This key already exists'));
    } catch (e) {
      print(e);
      emit(state.copyWith(loading: false, error: 'Process Fialed'));
    }
  }

  void setType(String type) => emit(state.copyWith(type: type));
}
