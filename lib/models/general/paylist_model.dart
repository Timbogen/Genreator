import 'package:genreator/models/general/track_model.dart';

class PlaylistModel {
  /// The id of the playlist
  String id = '';

  /// The name of the playlist
  String name = '';

  /// The name of the owner
  String owner = '';

  /// The available genres
  Set<String> genres = {};

  /// The link to the image
  String image = '';

  /// The tracks
  List<TrackModel> tracks = [];
}