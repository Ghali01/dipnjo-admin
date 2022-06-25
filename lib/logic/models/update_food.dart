import 'dart:io';

class UpdateFoodState {
  bool loaded;
  bool loading;
  String? image;
  String error;
  String? imageError;
  List addtions;
  Map? offer;
  Map? data;
  File? imageFile;
  bool? visiblity;
  UpdateFoodState({
    this.loaded = false,
    this.loading = false,
    this.image,
    this.error = '',
    this.imageError,
    this.addtions = const [],
    this.offer,
    this.data,
    this.imageFile,
    this.visiblity,
  });

  UpdateFoodState copyWith({
    bool? loaded,
    bool? loading,
    String? image,
    String? error,
    String? imageError,
    List? addtions,
    Map? offer,
    Map? data,
    File? imageFile,
    bool? visiblity,
  }) {
    return UpdateFoodState(
      loaded: loaded ?? this.loaded,
      loading: loading ?? this.loading,
      image: image ?? this.image,
      error: error ?? this.error,
      imageError: imageError ?? this.imageError,
      addtions: addtions ?? this.addtions,
      offer: offer ?? this.offer,
      data: data ?? this.data,
      imageFile: imageFile ?? this.imageFile,
      visiblity: visiblity ?? this.visiblity,
    );
  }
}
