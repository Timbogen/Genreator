import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:genreator/models/spotify/api_playlists_model.dart';

class PlaylistWidget extends StatelessWidget {
  /// The playlist that shall be displayed
  final ApiPlaylistModel? playlist;

  /// The callback
  final Function onTap;

  /// Constructor
  const PlaylistWidget({Key? key, this.playlist, required this.onTap}) : super(key: key);

  /// Returns the playlist icon or the preview image
  Widget _getIcon() {
    if ((playlist?.images?.isNotEmpty ?? false)) {
      return FadeInImage(
        image: NetworkImage(playlist?.images?[0].url ?? '', scale: 10),
        placeholder: const AssetImage('assets/preview_image.png'),
      );
    }
    return const Image(image: AssetImage('assets/preview_image.png'));
  }

  /// Returns the description for the playlist
  String _getDescription(BuildContext context) {
    if (playlist?.owner?.displayName != null) {
      return '${playlist?.owner?.displayName} - ${playlist?.tracks?.total} ${AppLocalizations.of(context)!.songs}';
    }
    return AppLocalizations.of(context)!.choosePlaylistDescription;
  }

  /// Build the layout
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// The playlist item
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => onTap(),
          child: Row(
            children: [
              /// Preview Image
              _getIcon(),
              const SizedBox(width: 12),

              /// Title and description
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist?.name ?? AppLocalizations.of(context)!.choosePlaylist,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(height: 4),
                  Text(_getDescription(context)),
                ],
              ),
            ],
          ),
        ),

        /// Spacing on the bottom
        const SizedBox(height: 12),
      ],
    );
  }
}
