class CategoryFoodsState {
  bool loaded;
  bool loading;
  bool isEnd;
  String error = '';
  int page;
  List foods = [];

  CategoryFoodsState({
    this.loaded = false,
    this.isEnd = false,
    this.error = '',
    this.loading = true,
    this.page = 1,
    this.foods = const [],
  });

  CategoryFoodsState copyWith({
    bool? loaded,
    bool? loading,
    bool? isEnd,
    String? error,
    int? page,
    List? foods,
  }) {
    return CategoryFoodsState(
      loaded: loaded ?? this.loaded,
      loading: loading ?? this.loading,
      isEnd: isEnd ?? this.isEnd,
      error: error ?? this.error,
      page: page ?? this.page,
      foods: foods ?? this.foods,
    );
  }
}
