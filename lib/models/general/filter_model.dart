class FilterModel {
  /// The name of the filter
  String name = '';

  /// The source playlist
  String source = '';

  /// The target playlist
  String target = '';

  /// The path to the source playlist's thumbnail
  String image = '';

  /// The allowed genres
  List<String> genres = [];

  /// Constructor
  FilterModel();

  /// Load data from a json object
  FilterModel.fromJson(dynamic json) {
    name = json['name'] ?? '';
    source = json['source'] ?? '';
    target = json['target'] ?? '';
    image = json['image'] ?? '';
    genres = json['genres'].forEach((genre) => genres.add(genre));
  }
}
