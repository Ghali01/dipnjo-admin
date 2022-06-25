import 'dart:convert';
import 'dart:io';

import 'package:admin/logic/models/update_food.dart';
import 'package:admin/logic/providers/foods.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateFoodCubit extends Cubit<UpdateFoodState> {
  int id;
  UpdateFoodCubit(this.id) : super(UpdateFoodState()) {
    get().then((value) => null);
  }

  void setImage() async {
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (files != null) {
      emit(state.copyWith(
          image: files.files.first.path,
          imageFile: File(files.files.first.path!),
          imageError: null));
    }
  }

  void addAddition() {
    var items = [
      ...(state.addtions),
      {
        'name': TextEditingController(),
        'loading': false,
        'added': false,
        'price': TextEditingController()
      }
    ];
    emit(state.copyWith(addtions: items));
  }

  void removeAddition(int index) async {
    try {
      var items = state.addtions.toList();
      var addition = items[index];
      if (addition['added']) {
        emit(state.copyWith(
            addtions: state.addtions.toList()..[index]['loading'] = true));
        await FoodsAPI.deleteAddition(addition['id']);
      }

      items.removeAt(index);
      emit(state.copyWith(addtions: items));
    } catch (e) {}
  }

  void save(String name, String desc, String price, String points) async {
    try {
      emit(state.copyWith(loading: true));
      await FoodsAPI.updateFood(id, state.data!['category'], name, desc,
          double.parse(price), points, state.image);
      emit(state.copyWith(loading: false));
    } catch (e) {
      print(e);
      emit(state.copyWith(error: "Process failed", loading: false));
    }
  }

  Future<void> get() async {
    try {
      emit(state.copyWith(loading: true));
      String rawData = await FoodsAPI.getFoodById(id);
      var data = jsonDecode(rawData);
      List additions = [];
      for (var e in data['additions']) {
        additions.add({
          'id': e['id'],
          'loading': false,
          'added': true,
          'name': TextEditingController(text: e['name']),
          'price': TextEditingController(text: e['price'].toString()),
        });
      }

      emit(state.copyWith(
        loaded: true,
        loading: false,
        data: data,
        visiblity: data['visiblity'],
        addtions: additions,
        offer: data['offer'],
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(error: "Process failed", loading: false));
    }
  }

  void saveAddition(int index) async {
    var addition = state.addtions[index];
    try {
      emit(state.copyWith(
          addtions: state.addtions.toList()..[index]['loading'] = true));
      int id = await FoodsAPI.saveAddition(
          addition['name'].text, double.parse(addition['price'].text), this.id);
      addition['loading'] = false;
      addition['added'] = true;
      addition['id'] = id;
      emit(state.copyWith(
          addtions: state.addtions.toList()..[index] = addition));
    } catch (e) {}
  }

  void setOffer(Map offer) => emit(state.copyWith(offer: offer));
  void changeVisiblity() async {
    try {
      emit(state.copyWith(loading: true));
      await FoodsAPI.setFoodVisiblity(id, !state.visiblity!);
      emit(state.copyWith(loading: false, visiblity: !state.visiblity!));
    } catch (e) {
      print(e);
      emit(state.copyWith(error: "Process failed", loading: false));
    }
  }
}
