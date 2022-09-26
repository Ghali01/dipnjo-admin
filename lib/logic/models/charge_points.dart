class ChargePointState {
  bool loading;
  bool done;
  String? token;
  ChargePointState({
    this.loading = false,
    this.done = false,
    this.token,
  });

  ChargePointState copyWith({
    bool? loading,
    bool? done,
    String? token,
  }) {
    return ChargePointState(
      loading: loading ?? this.loading,
      done: done ?? this.done,
      token: token ?? this.token,
    );
  }
}
