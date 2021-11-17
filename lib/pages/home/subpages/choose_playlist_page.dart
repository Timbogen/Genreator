import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:genreator/models/spotify/api_playlists_model.dart';
import 'package:genreator/pages/home/widgets/header_widget.dart';
import 'package:genreator/pages/home/widgets/playlist_widget.dart';
import 'package:genreator/services/spotify_service.dart';

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
      body: Padding(
        padding: const EdgeInsets.only(top: 32, left: 16, bottom: 16, right: 16),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            /// The header
            HeaderWidget(title: AppLocalizations.of(context)!.choosePlaylist),

            /// The playlists
            ListView(
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
          ],
        ),
      ),
    );
  }
}
