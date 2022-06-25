class CategoriesState {
  List? categories;
  int? currentId;
  bool loaded;
  String error;
  CategoriesState({
    this.categories,
    this.currentId,
    this.error = '',
    this.loaded = false,
  });

  CategoriesState copyWith({
    List? categories,
    int? currentId,
    bool? loaded,
    String? error,
  }) =>
      CategoriesState(
        categories: categories ?? this.categories,
        currentId: currentId ?? this.currentId,
        loaded: loaded ?? this.loaded,
        error: error ?? this.error,
      );
}
