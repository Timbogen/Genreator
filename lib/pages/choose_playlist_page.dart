import 'package:flutter/material.dart';
import 'package:genreator/models/spotify/api_playlists_model.dart';
import 'package:genreator/services/spotify_service.dart';
import 'package:genreator/widgets/header_widget.dart';
import 'package:genreator/widgets/playlist_widget.dart';

import '../utility.dart';

class ChoosePlaylistPage extends StatefulWidget {
  /// The callback that is executed when a playlist is selected
  final Function(ApiPlaylistModel) onSelection;

  /// Constructor
  const ChoosePlaylistPage({Key? key, required this.onSelection}) : super(key: key);

  /// Initialize state
  @override
  State<ChoosePlaylistPage> createState() => _ChoosePlaylistPageState();
}

class _ChoosePlaylistPageState extends State<ChoosePlaylistPage> {
  /// The spotify service
  final SpotifyService spotifyService = SpotifyService();

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
          ...spotifyService.playlists.values.map((playlist) => PlaylistWidget(
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
