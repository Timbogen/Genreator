import 'package:flutter/material.dart';
import 'package:genreator/models/general/filter_model.dart';
import 'package:genreator/models/general/paylist_model.dart';
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
  final PlaylistModel playlistInfo;

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
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (builder) => FilterListPage(
                title: translation().genres,
                items: widget.playlistInfo.genres.toList(),
                includedItems: widget.filter.includedGenres,
              ),
            )),
            child: Padding(
              padding: defaultPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// The title and description
                  TitleDescriptionWidget(
                    title: translation().genres,
                    description: translation().genresDescription(widget.filter.includedGenres.length),
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
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (builder) => FilterListPage(
                title: translation().artists,
                items: _getFilteredArtists(),
                includedItems: widget.filter.excludedArtists,
              ),
            )),
            child: Padding(
              padding: defaultPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// The title and description
                  TitleDescriptionWidget(
                    title: translation().artists,
                    description: translation().artistsDescription,
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
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (builder) => FilterListPage(
                title: translation().tracks,
                items: _getFilteredTracks(),
                includedItems: widget.filter.excludedTracks,
              ),
            )),
            child: Padding(
              padding: defaultPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// The title and description
                  TitleDescriptionWidget(
                    title: translation().tracks,
                    description: translation().tracksDescription,
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
