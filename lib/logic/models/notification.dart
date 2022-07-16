class NotificationState {
  TargetType type;
  int from;
  late int to;
  NotificationState({this.type = TargetType.all, this.from = 1950, int? to}) {
    this.to = to ?? DateTime.now().year;
  }

  NotificationState copyWith({
    TargetType? type,
    int? from,
    int? to,
  }) {
    return NotificationState(
      type: type ?? this.type,
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }
}

enum TargetType { all, age, user }
