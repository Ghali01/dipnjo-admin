enum CategoryDialogIntent { add, update }

class CategoryDialogState {
  bool loading;
  bool done;
  String error;
  CategoryDialogIntent intent;
  bool? visiblity;
  CategoryDialogState({
    this.loading = false,
    this.done = false,
    this.error = '',
    required this.intent,
    this.visiblity,
  });

  CategoryDialogState copyWith({
    bool? loading,
    bool? done,
    String? error,
    CategoryDialogIntent? intent,
    bool? visiblity,
  }) {
    return CategoryDialogState(
      loading: loading ?? this.loading,
      done: done ?? this.done,
      error: error ?? this.error,
      intent: intent ?? this.intent,
      visiblity: visiblity ?? this.visiblity,
    );
  }
}
