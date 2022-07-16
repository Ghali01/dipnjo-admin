class ProfileState {
  bool loaded;
  bool loading;
  bool noMore;
  List orders;
  Map profileData;
  int page;
  ProfileState({
    this.loaded = false,
    this.loading = false,
    this.noMore = false,
    this.orders = const [],
    required this.profileData,
    this.page = 1,
  });

  ProfileState copyWith({
    bool? loaded,
    bool? loading,
    bool? noMore,
    List? orders,
    Map? profileData,
    int? page,
  }) {
    return ProfileState(
      loaded: loaded ?? this.loaded,
      loading: loading ?? this.loading,
      noMore: noMore ?? this.noMore,
      orders: orders ?? this.orders,
      profileData: profileData ?? this.profileData,
      page: page ?? this.page,
    );
  }
}
