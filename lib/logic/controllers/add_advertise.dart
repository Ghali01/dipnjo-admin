import 'dart:convert';

import 'package:admin/logic/models/add_advertise.dart';
import 'package:admin/logic/providers/foods.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAdvertiseCubit extends Cubit<AddAdvertiseState> {
  AddAdvertiseCubit() : super(AddAdvertiseState()) {
    load().then((value) => null);
  }
  void sleectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String path = result.files.first.path!;
      emit(state.copyWith(image: path));
    }
  }

  Future<void> load() async {
    try {
      String rawData = await FoodsAPI.getAllFoods();
      var data = jsonDecode(rawData);
      emit(state.copyWith(loaded: true, foods: data));
    } catch (e) {}
  }

  void save(String title, String subtitle) async {
    // try {
    emit(state.copyWith(loading: true));
    String rawData =
        await FoodsAPI.addAd(title, subtitle, state.food!, state.image!);
    emit(state.copyWith(loading: false, done: true, rawData: rawData));
    // } catch (e) {
    //   print(e);
    //   emit(state.copyWith(error: 'proccess fialed', loading: false));
    // }
  }

  void setFood(int food) => emit(state.copyWith(food: food));
}
