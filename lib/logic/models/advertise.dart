class AdvertiseState {
  bool loaded;
  List? items;
  AdvertiseState({
    this.loaded = false,
    this.items,
  });

  AdvertiseState copyWith({
    bool? loaded,
    List? items,
  }) {
    return AdvertiseState(
      loaded: loaded ?? this.loaded,
      items: items ?? this.items,
    );
  }
}
