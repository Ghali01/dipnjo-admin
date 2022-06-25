class OfferDialogState {
  bool done;
  bool loading;
  String error;
  String type;
  Map? offer;
  OfferDialogState({
    this.done = false,
    this.loading = false,
    this.error = '',
    this.type = '1',
    this.offer,
  });

  OfferDialogState copyWith({
    bool? done,
    bool? loading,
    String? error,
    String? type,
    Map? offer,
  }) {
    return OfferDialogState(
      done: done ?? this.done,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      type: type ?? this.type,
      offer: offer ?? this.offer,
    );
  }
}
