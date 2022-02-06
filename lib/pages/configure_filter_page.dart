import 'package:flutter/material.dart';
import 'package:genreator/models/general/filter_model.dart';
import 'package:genreator/models/general/playlist_info_model.dart';
import 'package:genreator/pages/filter_list_page.dart';
import 'package:genreator/services/filter_service.dart';
import 'package:genreator/services/spotify_service.dart';
import 'package:genreator/theme.dart';
import 'package:genreator/utility.dart';
import 'package:genreator/widgets/action_button_widget.dart';
import 'package:genreator/widgets/header_widget.dart';
import 'package:genreator/widgets/title_description_widget.dart';
import 'package:numberpicker/numberpicker.dart';

import 'loading_page.dart';

class ConfigureFilterPage extends StatefulWidget {
  /// The inspected filter
  final FilterModel filter;

  /// The information about the playlist
  final PlaylistInfoModel playlistInfo;

  /// Constructor
  const ConfigureFilterPage({Key? key, required this.filter, required this.playlistInfo}) : super(key: key);

  /// Create the state
  @override
  _ConfigureFilterPageState createState() => _ConfigureFilterPageState();
}

class _ConfigureFilterPageState extends State<ConfigureFilterPage> with SingleTickerProviderStateMixin {
  /// The spotify service
  final _spotifyService = SpotifyService();

  /// The scene service
  final _filterService = FilterService();

  /// Returns a list containing the names of the filtered artists
  List<String> _getFilteredArtists() {
    return Set<String>.from(widget.filter
        .applyFilter(widget.playlistInfo, excludeArtists: false, excludeTracks: false)
        .map((track) => track.artist)).toList();
  }

  /// Returns a list containing the display names of the filtered tracks
  List<String> _getFilteredTracks() {
    return widget.filter
        .applyFilter(widget.playlistInfo, excludeTracks: false)
        .map((track) => track.displayName)
        .toList();
  }

  /// Runs the filter after confirmation of the user
  void _runFilter() {
    showConfirmDialog(
      context,
      translation().runFilter,
      translation().runFilterDescription(_spotifyService.playlists[widget.filter.target]?.name ?? ''),
      () async {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (builder) => LoadingPage(
            workload: (_) async => await _filterService.run(widget.filter, widget.playlistInfo),
            onFinish: (loadingContext) {
              // Close the loading page
              Navigator.of(loadingContext).pop();
              // Close the configure page
              Navigator.of(context).pop();
            },
          ),
        ));
      },
    );
  }

  /// Build the layout
  @override
  Widget build(BuildContext context) {
    final maxYear = DateTime.now().year;
    return Scaffold(
      /// Header
      appBar: HeaderWidget(title: translation().configureFilter(widget.filter.name)),

      /// Content
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: paddingSmall),

          /// Overview
          Padding(
            padding: sidePadding,
            child: Card(
                margin: EdgeInsets.zero,
                color: GenColors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(paddingSmall),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info),
                          const SizedBox(width: 8),
                          Text(
                            translation().filterInfo(_getFilteredTracks().length),
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        translation().filterInfoDescription,
                      ),
                    ],
                  ),
                )),
          ),
          const SizedBox(height: paddingSmall),

          /// Minimum release year
          Padding(
            padding: sidePadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translation().minReleaseYear,
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(
                    height: 30,
                    child: Switch(
                      value: widget.filter.minReleaseYearEnabled,
                      onChanged: (value) => setState(() => widget.filter.minReleaseYearEnabled = value),
                    ))
              ],
            ),
          ),
          const SizedBox(height: 4.0),
          Center(
            child: NumberPicker(
              value: widget.filter.minReleaseYear,
              axis: Axis.horizontal,
              selectedTextStyle: TextStyle(
                fontSize: 22.0,
                color: widget.filter.minReleaseYearEnabled ? GenColors.green : GenColors.lightGrey,
              ),
              minValue: 0,
              maxValue: maxYear,
              onChanged: (value) => setState(() => widget.filter.minReleaseYear = value),
            ),
          ),
          const SizedBox(height: 8.0),

          /// Maximum release year
          Padding(
            padding: sidePadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translation().maxReleaseYear,
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(
                    height: 30,
                    child: Switch(
                      value: widget.filter.maxReleaseYearEnabled,
                      onChanged: (value) => setState(() => widget.filter.maxReleaseYearEnabled = value),
                    ))
              ],
            ),
          ),
          const SizedBox(height: 4.0),
          Center(
            child: NumberPicker(
              value: widget.filter.maxReleaseYear,
              axis: Axis.horizontal,
              selectedTextStyle: TextStyle(
                fontSize: 22.0,
                color: widget.filter.maxReleaseYearEnabled ? GenColors.green : GenColors.lightGrey,
              ),
              minValue: 0,
              maxValue: maxYear,
              onChanged: (value) => setState(() => widget.filter.maxReleaseYear = value),
            ),
          ),
          const SizedBox(height: 8.0),

          /// Include genres
          InkWell(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(
                  builder: (builder) => FilterListPage(
                    title: translation().includedGenres,
                    items: widget.playlistInfo.genres.toList(),
                    includedItems: widget.filter.includedGenres,
                  ),
                ))
                .then((_) => setState(() {})),
            child: Padding(
              padding: defaultPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// The title and description
                  TitleDescriptionWidget(
                    title: translation().includedGenres,
                    description: translation().includedGenresDescription(widget.filter.includedGenres.length),
                  ),
                  const Spacer(),

                  /// The arrow
                  const Icon(Icons.navigate_next, size: 32)
                ],
              ),
            ),
          ),
          const SizedBox(height: 8.0),

          /// Include artists
          InkWell(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(
                  builder: (builder) => FilterListPage(
                    title: translation().includedArtists,
                    items: widget.playlistInfo.artists.toList(),
                    includedItems: widget.filter.includedArtists,
                  ),
                ))
                .then((_) => setState(() {})),
            child: Padding(
              padding: defaultPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// The title and description
                  TitleDescriptionWidget(
                    title: translation().includedArtists,
                    description: translation().includedArtistsDescription(widget.filter.includedArtists.length),
                  ),
                  const Spacer(),

                  /// The arrow
                  const Icon(Icons.navigate_next, size: 32)
                ],
              ),
            ),
          ),
          const SizedBox(height: 8.0),

          /// Include tracks
          InkWell(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(
                  builder: (builder) => FilterListPage(
                    title: translation().includedTracks,
                    items: widget.playlistInfo.tracks.map((track) => track.displayName).toList(),
                    includedItems: widget.filter.includedTracks,
                  ),
                ))
                .then((_) => setState(() {})),
            child: Padding(
              padding: defaultPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// The title and description
                  TitleDescriptionWidget(
                    title: translation().includedTracks,
                    description: translation().includedTracksDescription(widget.filter.includedTracks.length),
                  ),
                  const Spacer(),

                  /// The arrow
                  const Icon(Icons.navigate_next, size: 32)
                ],
              ),
            ),
          ),
          const SizedBox(height: 8.0),

          /// Exclude artists
          InkWell(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(
                  builder: (builder) => FilterListPage(
                    title: translation().excludedArtists,
                    items: _getFilteredArtists(),
                    includedItems: widget.filter.excludedArtists,
                  ),
                ))
                .then((_) => setState(() {})),
            child: Padding(
              padding: defaultPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// The title and description
                  TitleDescriptionWidget(
                    title: translation().excludedArtists,
                    description: translation().excludedArtistsDescription,
                  ),
                  const Spacer(),

                  /// Arrow
                  const Icon(Icons.navigate_next, size: 32)
                ],
              ),
            ),
          ),
          const SizedBox(height: 8.0),

          /// Exclude tracks
          InkWell(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(
                  builder: (builder) => FilterListPage(
                    title: translation().excludedTracks,
                    items: _getFilteredTracks(),
                    includedItems: widget.filter.excludedTracks,
                  ),
                ))
                .then((_) => setState(() {})),
            child: Padding(
              padding: defaultPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// The title and description
                  TitleDescriptionWidget(
                    title: translation().excludedTracks,
                    description: translation().excludedTracksDescription,
                  ),
                  const Spacer(),

                  /// Arrow
                  const Icon(Icons.navigate_next, size: 32)
                ],
              ),
            ),
          ),

          /// Clear tracks before filtering
          InkWell(
            onTap: () => setState(() => widget.filter.clearBefore = !widget.filter.clearBefore),
            child: Padding(
              padding: defaultPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// The title and description
                  TitleDescriptionWidget(
                    title: translation().clearPlaylist,
                    description: translation().clearPlaylistDescription,
                  ),
                  const Spacer(),

                  /// The switch
                  Switch(
                    value: widget.filter.clearBefore,
                    onChanged: (_) => setState(() => widget.filter.clearBefore = !widget.filter.clearBefore),
                  )
                ],
              ),
            ),
          ),

          /// Start the filter
          Padding(
            padding: defaultPadding,
            child: ActionButtonWidget(
              icon: Icons.play_arrow,
              text: translation().runFilter,
              onPressed: _runFilter,
            ),
          )
        ],
      ),
    );
  }
}
