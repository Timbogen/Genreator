import 'package:flutter/material.dart';
import 'package:genreator/models/general/filter_model.dart';
import 'package:genreator/models/general/paylist_model.dart';
import 'package:genreator/pages/configure_filter_page.dart';
import 'package:genreator/pages/loading_page.dart';
import 'package:genreator/services/filter_service.dart';
import 'package:genreator/services/spotify_service.dart';
import 'package:genreator/widgets/action_button_widget.dart';
import 'package:genreator/widgets/header_button_widget.dart';
import 'package:genreator/widgets/header_widget.dart';
import 'package:genreator/widgets/playlist_image_widget.dart';
import 'package:genreator/widgets/playlist_widget.dart';

import '../theme.dart';
import '../utility.dart';
import 'choose_playlist_page.dart';

class FilterPage extends StatefulWidget {
  /// The inspected filter
  final FilterModel filter;

  /// Callback for on delete
  final Function onDelete;

  /// Constructor
  const FilterPage({Key? key, required this.filter, required this.onDelete}) : super(key: key);

  /// Initialize state
  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  /// The spotify service
  final _spotifyService = SpotifyService();

  /// The filter service
  final _filterService = FilterService();

  /// Returns true if the filter can be executed
  bool isValid() {
    bool hasSource = _spotifyService.playlists[widget.filter.source] != null;
    bool hasTarget = _spotifyService.playlists[widget.filter.target] != null;
    return hasSource && hasTarget;
  }

  /// Build the layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Header
      appBar: HeaderWidget(
        title: widget.filter.name,
        onEdit: (name) {
          setState(() => widget.filter.name = name);
          _filterService.save();
        },
        actions: [
          /// Delete button
          HeaderButtonWidget(
            icon: Icons.delete,
            onPressed: () {
              showConfirmDialog(
                context,
                translation().deleteFilter,
                translation().deleteFilterDescription,
                () async {
                  widget.onDelete();
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ],
      ),

      /// Content
      body: ListView(
        padding: defaultPadding,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          /// Name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: widget.filter.hashCode,
                child: PlaylistImageWidget(
                  image: widget.filter.image,
                  width: 200,
                  height: 200,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          /// Information
          Card(
            margin: EdgeInsets.zero,
            color: GenColors.grey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Source playlist
                const SizedBox(height: paddingSmall),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                  child: Text(
                    translation().sourcePlaylist,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                const SizedBox(height: 8),
                PlaylistWidget(
                  padding: paddingSmall,
                  arrow: true,
                  playlist: _spotifyService.playlists[widget.filter.source],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChoosePlaylistPage(
                        onSelection: (playlist) => setState(() {
                          widget.filter.source = playlist.id ?? '';
                          widget.filter.image = getApiPlaylistImage(playlist);
                          _filterService.save();
                        }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// Target playlist
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                  child: Text(
                    translation().targetPlaylist,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                const SizedBox(height: 8),
                PlaylistWidget(
                  padding: paddingSmall,
                  arrow: true,
                  playlist: _spotifyService.playlists[widget.filter.target],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChoosePlaylistPage(
                        onSelection: (playlist) => setState(() {
                          widget.filter.target = playlist.id ?? '';
                          _filterService.save();
                        }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),

          /// Start filter
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.info),
                  const SizedBox(width: 8),
                  Text(
                    translation().startFilter,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                translation().startDescription,
              ),
            ],
          ),
          const SizedBox(
            height: paddingBig,
          ),

          /// Start the filter
          ActionButtonWidget(
            icon: Icons.play_arrow,
            text: translation().configureAndRunFilter,
            onPressed: isValid()
                ? () {
                    /// Load playlist info and then show configuration
                    var playlistInfo = PlaylistModel();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) => LoadingPage(
                        showProgress: true,
                        workload: (onProgress) async {
                          playlistInfo =
                              await _spotifyService.loadPlaylistInfo(context, widget.filter.source, onProgress);
                        },
                        onFinish: (context) {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (builder) =>
                                ConfigureFilterPage(filter: widget.filter, playlistInfo: playlistInfo),
                          )).then((_) {
                            _filterService.save();
                            setState(() {});
                          });
                        },
                      ),
                    ));
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
