import 'dart:convert';

import 'package:admin/logic/controllers/categories.dart';
import 'package:admin/logic/models/category_dialog.dart';
import 'package:admin/logic/providers/categories.dart';
import 'package:admin/logic/providers/foods.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryDialogCubit extends Cubit<CategoryDialogState> {
  CategoriesCubit categoriesCubit;
  CategoryDialogCubit(
      CategoryDialogIntent intent, this.categoriesCubit, bool? visiblity)
      : super(CategoryDialogState(intent: intent, visiblity: visiblity));

  void save(String name, int? id) async {
    if (state.intent == CategoryDialogIntent.add) {
      try {
        emit(state.copyWith(loading: true));
        String rawData = await CategoryAPI.post(name);
        var data = jsonDecode(rawData);
        categoriesCubit.add(data['name'], data['id']);
        emit(state.copyWith(done: true));
      } catch (e) {
        emit(state.copyWith(error: "Process failed", loading: false));
      }
    } else {
      try {
        emit(state.copyWith(loading: true));
        await CategoryAPI.put(name, id!);
        categoriesCubit.update(name, id);
        emit(state.copyWith(done: true));
      } catch (e) {
        emit(state.copyWith(error: "Process failed", loading: false));
      }
    }
  }

  void setVisibilty(int id) async {
    try {
      bool value = !state.visiblity!;
      emit(state.copyWith(loading: true));
      await FoodsAPI.setCategoryVisiblity(id, value);
      emit(state.copyWith(loading: false, visiblity: value));
      categoriesCubit.updateVisibity(value, id);
    } catch (e) {
      print(e);
      emit(state.copyWith(error: "Process failed", loading: false));
    }
  }
}
