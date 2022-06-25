class AddFoodState {
  bool done;
  bool loading;
  String? image;
  String error;
  String? imageError;
  List addtions;
  AddFoodState({
    this.done = false,
    this.error = '',
    this.loading = false,
    this.image,
    this.imageError,
    this.addtions = const [],
  });

  AddFoodState copyWith({
    bool? done,
    bool? loading,
    String? image,
    String? error,
    String? imageError,
    List? addtions,
  }) {
    return AddFoodState(
      done: done ?? this.done,
      loading: loading ?? this.loading,
      image: image ?? this.image,
      error: error ?? this.error,
      imageError: imageError ?? this.imageError,
      addtions: addtions ?? this.addtions,
    );
  }
}
