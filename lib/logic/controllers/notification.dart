import 'package:admin/logic/models/notification.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState());

  void setType(TargetType type) => emit(state.copyWith(type: type));
  void setRange(int from, int to) => emit(state.copyWith(from: from, to: to));
}
