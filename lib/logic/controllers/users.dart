import 'dart:convert';

import 'package:admin/logic/models/users.dart';
import 'package:admin/logic/providers/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersState()) {
    load().then((value) => null);
  }

  Future<void> load() async {
    try {
      emit(state.copyWith(loading: true));
      List r = await UsersAPI.getUser(state.page, state.search);
      if (r[1] == state.search) {
        String rawData = r[0];
        var data = jsonDecode(rawData);
        List items = [...(state.users), ...data];
        emit(state.copyWith(
            loading: false,
            loaded: true,
            noMore: data.length < 20,
            page: state.page + 1,
            users: items));
      }
    } catch (e) {}
  }

  void setTextSearch(String text) {
    if (text == state.search) return;
    emit(state.copyWith(search: text, users: [], noMore: false, page: 1));
    load().then((value) => null);
  }
}
