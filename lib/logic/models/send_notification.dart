class SendNotificationState {
  bool loading;
  bool done;
  SendNotificationState({
    this.loading = false,
    this.done = false,
  });

  SendNotificationState copyWith({
    bool? loading,
    bool? done,
  }) {
    return SendNotificationState(
      loading: loading ?? this.loading,
      done: done ?? this.done,
    );
  }
}
