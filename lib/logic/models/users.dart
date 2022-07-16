class UsersState {
  bool loading;
  bool noMore;
  bool loaded;
  String search;
  int page;
  List users;
  UsersState({
    this.loading = false,
    this.noMore = false,
    this.loaded = false,
    this.search = '',
    this.page = 1,
    this.users = const [],
  });

  UsersState copyWith({
    bool? loading,
    bool? noMore,
    bool? loaded,
    String? search,
    int? page,
    List? users,
  }) {
    return UsersState(
      loading: loading ?? this.loading,
      noMore: noMore ?? this.noMore,
      loaded: loaded ?? this.loaded,
      search: search ?? this.search,
      page: page ?? this.page,
      users: users ?? this.users,
    );
  }
}
