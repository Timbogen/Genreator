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
    json['genres'].forEach((genre) => genres.add(genre));
  }

  /// Convert data to json object
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['source'] = source;
    map['target'] = target;
    map['image'] = image;
    map['genres'] = genres;
    return map;
  }
}
