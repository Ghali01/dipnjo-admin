import 'package:admin/logic/models/add_food.dart';
import 'package:admin/logic/providers/foods.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFoodCubit extends Cubit<AddFoodState> {
  AddFoodCubit() : super(AddFoodState());

  void setImage() async {
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (files != null) {
      emit(state.copyWith(image: files.files.first.path, imageError: null));
    }
  }

  void addAddition() {
    var items = [
      ...(state.addtions),
      {'name': TextEditingController(), 'price': TextEditingController()}
    ];
    emit(state.copyWith(addtions: items));
  }

  void removeAddition(int index) {
    var items = state.addtions.toList();
    items.removeAt(index);
    emit(state.copyWith(addtions: items));
  }

  void save(String name, int category, String desc, String price,
      String points) async {
    if (state.image == null) {
      emit(state.copyWith(imageError: "select image"));
      return;
    }
    List additions = state.addtions
        .map((addi) =>
            {"name": addi['name'].text, 'price': int.parse(addi['price'].text)})
        .toList();
    try {
      emit(state.copyWith(loading: true));
      await FoodsAPI.post(name, category, desc, double.parse(price),
          state.image!, additions, points);
      emit(state.copyWith(loading: false, done: true));
    } catch (e) {
      print(e);
      emit(state.copyWith(error: "Process failed", loading: false));
    }
  }
}
