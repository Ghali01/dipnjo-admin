import 'package:admin/logic/models/orders.dart';

class OrderState {
  Map? data;
  OrderStatus? status;
  bool loaded;
  OrderStatus? nextStatus;
  bool loading;
  OrderState({
    this.data,
    this.status,
    this.loaded = false,
    this.nextStatus,
    this.loading = false,
  });

  OrderState copyWith({
    Map? data,
    OrderStatus? status,
    bool? loaded,
    OrderStatus? nextStatus,
    bool? loading,
  }) {
    return OrderState(
      data: data ?? this.data,
      status: status ?? this.status,
      loaded: loaded ?? this.loaded,
      nextStatus: nextStatus ?? this.nextStatus,
      loading: loading ?? this.loading,
    );
  }
}
