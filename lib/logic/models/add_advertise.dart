class AddAdvertiseState {
  bool loading;
  String? image;
  String error;
  bool done;
  String? rawData;
  bool loaded;
  List? foods;
  int? food;
  AddAdvertiseState({
    this.loading = false,
    this.image,
    this.error = '',
    this.done = false,
    this.rawData,
    this.loaded = false,
    this.foods,
    this.food,
  });

  AddAdvertiseState copyWith({
    bool? loading,
    String? image,
    String? error,
    bool? done,
    String? rawData,
    bool? loaded,
    List? foods,
    int? food,
  }) {
    return AddAdvertiseState(
      loading: loading ?? this.loading,
      image: image ?? this.image,
      error: error ?? this.error,
      done: done ?? this.done,
      rawData: rawData ?? this.rawData,
      loaded: loaded ?? this.loaded,
      foods: foods ?? this.foods,
      food: food ?? this.food,
    );
  }
}
