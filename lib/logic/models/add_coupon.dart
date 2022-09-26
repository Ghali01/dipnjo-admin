class AddCouponState {
  bool done;
  bool loading;
  String type;
  String error;
  Map? data;
  AddCouponState({
    this.done = false,
    this.loading = false,
    this.type = 'p',
    this.error = '',
    this.data,
  });

  AddCouponState copyWith({
    bool? done,
    bool? loading,
    String? type,
    String? error,
    Map? data,
  }) {
    return AddCouponState(
      done: done ?? this.done,
      loading: loading ?? this.loading,
      type: type ?? this.type,
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }
}
