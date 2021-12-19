class TrackModel {
  /// The uri of the track
  String uri = '';

  /// The name of the track
  String name = '';

  /// The main artist of the track
  String artist = '';

  /// The release date
  DateTime? releaseDate;

  /// The genres
  Set<String> genres = {};

  /// The display name of the track
  String get displayName {
    return '$artist  - $name';
  }
}