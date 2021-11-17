import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:genreator/models/general/filter_model.dart';
import 'package:genreator/pages/home/subpages/choose_playlist_page.dart';
import 'package:genreator/pages/home/widgets/header_widget.dart';
import 'package:genreator/pages/home/widgets/playlist_widget.dart';
import 'package:genreator/services/spotify_service.dart';
import 'package:genreator/theme.dart';

class AddFilterArguments {
  /// Constructor
  AddFilterArguments();
}

class AddFilterPage extends StatefulWidget {
  /// True if a filter is edited
  final bool editMode;

  /// True if a filter is edited
  final FilterModel filter;

  /// The callback if the edition was confirm
  final Function(FilterModel) onConfirm;

  /// Constructor
  const AddFilterPage({Key? key, required this.editMode, required this.filter, required this.onConfirm})
      : super(key: key);

  /// Initialize state
  @override
  State<AddFilterPage> createState() => _AddFilterPageState();
}

class _AddFilterPageState extends State<AddFilterPage> {
  /// The spotify service
  final SpotifyService _spotifyService = SpotifyService();

  /// Returns the confirm callback or null if the filter isn't correct
  VoidCallback? _confirm() {
    if (widget.filter.name != '' && widget.filter.target != '' && widget.filter.source != '') {
      return () {
        widget.onConfirm(widget.filter);
        Navigator.of(context).pop();
      };
    }
    return null;
  }

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
            HeaderWidget(title: AppLocalizations.of(context)!.addFilter),

            /// Name
            Text(
              AppLocalizations.of(context)!.name,
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (text) => setState(() => widget.filter.name = text),
              decoration: const InputDecoration( fillColor: GenColors.grey, filled: true),
            ),
            const SizedBox(height: 24),

            /// Source playlist
            Text(
              AppLocalizations.of(context)!.sourcePlaylist,
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(height: 12),
            PlaylistWidget(
              playlist: _spotifyService.playlists[widget.filter.source],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChoosePlaylistPage(
                    onSelection: (playlist) => setState(() {
                      widget.filter.source = playlist.id ?? '';
                      widget.filter.image = playlist.images?[0].url ?? '';
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// Target playlist
            Text(
              AppLocalizations.of(context)!.targetPlaylist,
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(height: 12),
            PlaylistWidget(
              playlist: _spotifyService.playlists[widget.filter.target],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChoosePlaylistPage(
                    onSelection: (playlist) => setState(() => widget.filter.target = playlist.id ?? ''),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _confirm(),
                  child: Text(AppLocalizations.of(context)!.confirm),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
