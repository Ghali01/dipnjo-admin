import 'dart:convert';

import 'package:admin/logic/models/category_food.dart';
import 'package:admin/logic/providers/foods.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryFoodsCubit extends Cubit<CategoryFoodsState> {
  late int id;
  CategoryFoodsCubit() : super(CategoryFoodsState());
  Future<void> load() async {
    try {
      emit(state.copyWith(loading: true));
      String rawData = await FoodsAPI.getCategoryFoods(id, state.page);
      List data = jsonDecode(rawData);
      // print(state.loaded);
      var items = [...(state.foods), ...data];
      emit(state.copyWith(
        foods: items,
        loaded: true,
        loading: false,
        isEnd: data.length < 10,
        page: state.page + 1,
      ));
    } catch (e) {
      emit(state.copyWith(error: "Process failed", loading: false));
    }
  }

  void setId(int id) {
    this.id = id;
    emit(state.copyWith(foods: []));
    emit(CategoryFoodsState().copyWith(foods: []));
    // print(state.foods);
    load().then((value) => null);
  }
}
