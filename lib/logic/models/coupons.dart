class CouponsState {
  bool loading;
  bool loaded;
  bool noMore;
  int page;
  String search;
  List coupons;
  CouponsState({
    this.loading = false,
    this.loaded = false,
    this.noMore = false,
    this.page = 1,
    this.search = '',
    this.coupons = const [],
  });

  CouponsState copyWith({
    bool? loading,
    bool? loaded,
    bool? noMore,
    int? page,
    String? search,
    List? coupons,
  }) {
    return CouponsState(
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
      noMore: noMore ?? this.noMore,
      page: page ?? this.page,
      search: search ?? this.search,
      coupons: coupons ?? this.coupons,
    );
  }
}
