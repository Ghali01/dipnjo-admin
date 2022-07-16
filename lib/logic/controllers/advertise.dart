import 'dart:convert';

import 'package:admin/logic/models/advertise.dart';
import 'package:admin/logic/providers/foods.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdvertiseCubit extends Cubit<AdvertiseState> {
  AdvertiseCubit() : super(AdvertiseState()) {
    load().then((value) => null);
  }

  Future<void> load() async {
    try {
      String rawData = await FoodsAPI.getAds();
      var data = jsonDecode(rawData);
      emit(state.copyWith(items: data, loaded: true));
    } catch (e) {}
  }

  void delete(int id) async {
    try {
      List items = state.items!.toList();
      int index = items.indexWhere((element) => element['id'] == id);
      items[index]['loading'] = true;
      emit(state.copyWith(items: items));
      await FoodsAPI.deleteAd(id);
      items = items.toList();
      items.removeAt(index);
      emit(state.copyWith(items: items));
    } catch (e) {}
  }

  void add(String raw) {
    var data = jsonDecode(raw);
    List items = state.items!.toList();
    items.add(data);
    emit(state.copyWith(items: items));
  }
}
