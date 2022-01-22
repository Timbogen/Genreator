import 'package:flutter/material.dart';
import 'package:genreator/models/general/playlist_info_model.dart';
import 'package:genreator/theme.dart';
import 'package:genreator/utility.dart';
import 'package:genreator/widgets/playlist_image_widget.dart';
import 'package:genreator/widgets/title_description_widget.dart';

class PlaylistWidget extends StatelessWidget {
  /// The playlist that shall be displayed
  final PlaylistModel? playlist;

  /// The callback
  final Function onTap;

  /// True if an arrow shall be shown on the right
  final bool arrow;

  /// The side padding
  final double padding;

  /// Constructor
  const PlaylistWidget({
    Key? key,
    this.playlist,
    required this.onTap,
    this.arrow = false,
    this.padding = paddingBig,
  }) : super(key: key);

  /// Returns the description for the playlist
  String _getDescription(BuildContext context) {
    if (playlist != null) {
      return '${playlist?.owner} - ${playlist?.total} ${translation().songs}';
    }
    return translation().choosePlaylistDescription;
  }

  /// Build the layout
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// The playlist item
        InkWell(
          onTap: () => onTap(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: padding),
            child: Row(
              children: [
                /// Preview Image
                PlaylistImageWidget(
                  image: playlist?.image ?? '',
                  width: 64,
                  height: 64,
                ),
                const SizedBox(width: 16),

                /// Title and description
                TitleDescriptionWidget(
                  title: playlist?.name ?? translation().choosePlaylist,
                  description: _getDescription(context),
                ),
                const Spacer(),

                /// Arrow
                Visibility(
                  visible: arrow,
                  child: const Icon(Icons.navigate_next, size: 32),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
