import 'package:flutter/material.dart';
import 'package:genreator/models/general/filter_model.dart';
import 'package:genreator/pages/add_filter_page.dart';
import 'package:genreator/pages/filter_page.dart';
import 'package:genreator/services/filter_service.dart';
import 'package:genreator/services/spotify_service.dart';
import 'package:genreator/theme.dart';
import 'package:genreator/widgets/action_button_widget.dart';
import 'package:genreator/widgets/playlist_image_widget.dart';
import 'package:genreator/widgets/title_description_widget.dart';

import '../utility.dart';

class TitleHeader extends StatelessWidget implements PreferredSizeWidget {
  /// Constructor
  const TitleHeader({Key? key}) : super(key: key);

  /// Build the layout
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: paddingBig, top: 56, right: paddingBig, bottom: 16),
      child: Text(
        translation().filters,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }

  /// The preferred height of the app bar
  @override
  Size get preferredSize => const Size(double.infinity, 92);
}

class HomePage extends StatefulWidget {
  /// Constructor
  const HomePage({Key? key}) : super(key: key);

  /// Initialize state
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// The spotify service
  final SpotifyService _spotifyService = SpotifyService();

  /// The filter service
  final FilterService _filterService = FilterService();

  /// Build the layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Header
      appBar: const TitleHeader(),

      /// Content
      body: Column(
        children: [
          ..._filterService.filters.map(
            (filter) => InkWell(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (builder) => FilterPage(
                      filter: filter,
                      onDelete: () => setState(() => _filterService.removeFilter(filter)),
                    ),
                  ))
                  .then((_) => setState(() {})),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingBig, vertical: 8.0),
                child: Row(
                  children: [
                    Hero(
                      tag: filter.hashCode,
                      child: PlaylistImageWidget(
                        image: filter.image,
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const SizedBox(width: 16),

                    /// Title and description
                    TitleDescriptionWidget(
                      title: filter.name,
                      description: translation().aboutShort(
                        _spotifyService.playlists[filter.source]?.name ?? '',
                        _spotifyService.playlists[filter.target]?.name ?? '',
                      ),
                    ),
                    const Spacer(),

                    /// Arrow
                    const Icon(Icons.navigate_next, size: 32)
                  ],
                ),
              ),
            ),
          ),

          /// Warning if there are no filters
          Visibility(
            visible: _filterService.filters.isEmpty,
            child: Padding(
              padding: defaultPadding,
              child: Row(
                children: [
                  const Icon(
                    Icons.info,
                    size: 32,
                    color: GenColors.lightGrey,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    translation().noFilters,
                    style: Theme.of(context).textTheme.headline5,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),

          /// Start the filter
          Padding(
            padding: defaultPadding,
            child: ActionButtonWidget(
              icon: Icons.add,
              text: translation().addFilter,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFilterPage(
                    editMode: false,
                    filter: FilterModel(),
                    onConfirm: (filter) => setState(() => setState(() => _filterService.addFilter(filter))),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
