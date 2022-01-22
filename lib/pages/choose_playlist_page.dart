import 'package:flutter/material.dart';
import 'package:genreator/models/general/playlist_info_model.dart';
import 'package:genreator/services/spotify_service.dart';
import 'package:genreator/widgets/header_widget.dart';
import 'package:genreator/widgets/playlist_widget.dart';

import '../utility.dart';

class ChoosePlaylistPage extends StatefulWidget {
  /// True if 'Liked songs shall also be seen
  final bool showLikedSongs;

  /// The callback that is executed when a playlist is selected
  final Function(PlaylistModel) onSelection;

  /// Constructor
  const ChoosePlaylistPage({Key? key, this.showLikedSongs = true, required this.onSelection}) : super(key: key);

  /// Initialize state
  @override
  State<ChoosePlaylistPage> createState() => _ChoosePlaylistPageState();
}

class _ChoosePlaylistPageState extends State<ChoosePlaylistPage> {
  /// The spotify service
  final SpotifyService spotifyService = SpotifyService();

  /// The playlists to be shown
  Iterable<PlaylistModel> playlists = const Iterable.empty();

  /// Hide the liked songs (if necessary)
  @override
  void initState() {
    super.initState();
    if (!widget.showLikedSongs) {
      playlists = spotifyService.playlists.values.where((playlist) => playlist.id != SpotifyService.likedSongsID);
    } else {
      playlists = spotifyService.playlists.values;
    }
  }

  /// Build the layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Header
      appBar: HeaderWidget(title: translation().choosePlaylist),

      /// Content
      body: ListView(
        padding: const EdgeInsets.all(10),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          ...playlists.map((playlist) => PlaylistWidget(
                playlist: playlist,
                onTap: () {
                  widget.onSelection(playlist);
                  Navigator.of(context).pop();
                },
              ))
        ],
      ),
    );
  }
}
