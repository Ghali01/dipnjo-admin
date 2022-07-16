import 'package:admin/logic/models/notification.dart';
import 'package:admin/logic/models/send_notification.dart';
import 'package:admin/logic/providers/notification.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendNotificationCubit extends Cubit<SendNotificationState> {
  SendNotificationCubit() : super(SendNotificationState());
  void send(TargetType type, String title, String body, int? id, int? from,
      int? to) async {
    try {
      emit(state.copyWith(loading: true));
      await NotificiationAPI.send(type, title, body,
          id: id, from: from, to: to);
      emit(state.copyWith(loading: false, done: true));
    } catch (e) {}
  }
}
