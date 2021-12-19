import 'package:genreator/models/general/paylist_model.dart';
import 'package:genreator/models/general/track_model.dart';

class FilterModel {
  /// The name of the filter
  String name = '';

  /// The source playlist
  String source = '';

  /// The target playlist
  String target = '';

  /// The path to the source playlist's thumbnail
  String image = '';

  /// True if the min release year filter is enabled
  bool minReleaseYearEnabled = false;

  /// The minimum release year
  int minReleaseYear = DateTime.now().year;

  /// True if the max release year filter is enabled
  bool maxReleaseYearEnabled = false;

  /// The maximum release year
  int maxReleaseYear = DateTime.now().year;

  /// The included genres (contains the "name" of the genres)
  var includedGenres = <String>{};

  /// The excluded artists (contains the "name" of the artists)
  var excludedArtists = <String>{};

  /// The excluded tracks (contains the "displayName" of the tracks)
  var excludedTracks = <String>{};

  /// True if the playlist shall be cleared before filling
  var clearBefore = false;

  /// Constructor
  FilterModel();

  /// Load data from a json object
  FilterModel.fromJson(dynamic json) {
    name = json['name'] ?? '';
    source = json['source'] ?? '';
    target = json['target'] ?? '';
    image = json['image'] ?? '';
    minReleaseYearEnabled = json['minReleaseYearEnabled'];
    minReleaseYear = json['minReleaseYear'];
    maxReleaseYearEnabled = json['maxReleaseYearEnabled'];
    maxReleaseYear = json['maxReleaseYear'];
    includedGenres = Set.from(json['includedGenres']);
    excludedArtists = Set.from(json['excludedArtists']);
    excludedTracks = Set.from(json['excludedTracks']);
    clearBefore = json['clearBefore'] ?? false;
  }

  /// Convert data to json object
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['source'] = source;
    map['target'] = target;
    map['image'] = image;
    map['minReleaseYearEnabled'] = minReleaseYearEnabled;
    map['minReleaseYear'] = minReleaseYear;
    map['maxReleaseYearEnabled'] = maxReleaseYearEnabled;
    map['maxReleaseYear'] = maxReleaseYear;
    map['includedGenres'] = includedGenres.toList();
    map['excludedArtists'] = excludedArtists.toList();
    map['excludedTracks'] = excludedTracks.toList();
    map['clearBefore'] = clearBefore;
    return map;
  }

  /// Applies the filter to a given playlist
  List<TrackModel> applyFilter(PlaylistModel playlist, {bool excludeArtists = true, bool excludeTracks = true}) {
    return playlist.tracks.where((track) {
      // Check the release year
      if (minReleaseYearEnabled || maxReleaseYearEnabled) {
        final releaseDate = track.releaseDate;
        if (releaseDate == null) return false;
        if (minReleaseYearEnabled && minReleaseYear > releaseDate.year) return false;
        if (maxReleaseYearEnabled && maxReleaseYear < releaseDate.year) return false;
      }

      // Check if the at least on genre of the track is included
      if (!track.genres.any((genre) => includedGenres.contains(genre))) return false;

      // Check if the artist is excluded
      if (excludeArtists && excludedArtists.contains(track.artist)) return false;

      // Check if the track is excluded
      if (excludeTracks && excludedTracks.contains(track.displayName)) return false;

      return true;
    }).toList();
  }
}
