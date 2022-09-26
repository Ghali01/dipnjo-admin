import 'package:admin/logic/models/charge_points.dart';
import 'package:admin/logic/providers/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChargePointsCubit extends Cubit<ChargePointState> {
  ChargePointsCubit() : super(ChargePointState());

  void setToken(String token) => emit(state.copyWith(token: token));
  void charge(int points) async {
    try {
      emit(state.copyWith(loading: true));
      await UsersAPI.chargePoints(state.token!, points);
      emit(state.copyWith(loading: false, done: true));
    } catch (e) {}
  }
}
