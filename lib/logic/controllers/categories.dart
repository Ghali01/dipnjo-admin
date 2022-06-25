import 'dart:convert';

import 'package:admin/logic/models/categories.dart';
import 'package:admin/logic/providers/categories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesState()) {
    load().then((value) => null);
  }

  void setCategory(int id) => emit(state.copyWith(currentId: id));

  Future<void> load() async {
    try {
      String rawData = await CategoryAPI.get();
      List categories = jsonDecode(rawData);
      emit(state.copyWith(
          categories: categories,
          loaded: true,
          currentId: categories.isNotEmpty ? categories.first['id'] : null));
    } catch (e) {
      emit(state.copyWith(error: 'Process failed'));
    }
  }

  void add(String name, int id) {
    var items = [
      ...(state.categories!),
      {"name": name, "id": id}
    ];
    emit(state.copyWith(categories: items));
  }

  void update(String name, int id) {
    var items = state.categories!.toList();
    int index = items.indexWhere((element) => element['id'] == id);
    items[index]['name'] = name;
    emit(state.copyWith(categories: items));
  }

  void updateVisibity(bool value, int id) {
    var items = state.categories!.toList();
    int index = items.indexWhere((element) => element['id'] == id);
    items[index]['visiblity'] = value;
    emit(state.copyWith(categories: items));
  }
}
