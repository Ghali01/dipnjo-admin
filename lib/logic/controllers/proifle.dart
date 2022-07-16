import 'dart:convert';

import 'package:admin/logic/models/proifle.dart';
import 'package:admin/logic/providers/orders.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(Map data) : super(ProfileState(profileData: data)) {
    load().then((value) => null);
  }
  Future<void> load() async {
    try {
      emit(state.copyWith(loading: true));
      String rawData =
          await OrdersAPI.getProfileOrders(state.profileData['id'], state.page);
      var data = jsonDecode(rawData);
      List items = [
        ...(state.orders),
        ...data,
      ];
      emit(state.copyWith(
          loaded: true,
          loading: false,
          noMore: data.length < 25,
          orders: items,
          page: state.page + 1));
    } catch (e) {}
  }
}
