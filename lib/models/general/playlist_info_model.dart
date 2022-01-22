import 'package:genreator/models/general/track_model.dart';

class PlaylistInfoModel {
  /// The available genres
  Set<String> genres = {};

  /// The available artists
  Set<String> artists = {};

  /// The tracks
  List<TrackModel> tracks = [];
}

class PlaylistModel {
  /// The id of the playlist
  String id = '';

  /// The name of the playlist
  String name = '';

  /// The owner of the playlist
  String owner = '';

  /// The link to the image
  String image = '';

  /// The total number of tracks
  int total = 0;

  /// Link to the tracks api
  String tracksHref = '';
}

