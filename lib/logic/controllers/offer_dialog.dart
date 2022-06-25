import 'dart:convert';

import 'package:admin/logic/models/offer_dialog.dart';
import 'package:admin/logic/providers/foods.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfferDialogCubit extends Cubit<OfferDialogState> {
  OfferDialogCubit() : super(OfferDialogState());
  void setType(String type) => emit(state.copyWith(type: type));

  void save(int food, String value, String end) async {
    try {
      emit(state.copyWith(loading: true));
      String rawData =
          await FoodsAPI.setOffer(food, state.type, double.parse(value), end);
      var data = jsonDecode(rawData);
      emit(state.copyWith(done: true, loading: false, offer: data));
    } catch (e) {
      print(e);
      emit(state.copyWith(error: "Process failed", loading: false));
    }
  }
}
