import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:genreator/models/general/filter_model.dart';
import 'package:genreator/pages/home/subpages/add_filter_page.dart';
import 'package:genreator/pages/home/subpages/filter_page.dart';
import 'package:genreator/services/filter_service.dart';
import 'package:genreator/services/spotify_service.dart';

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
      body: Padding(
        padding: const EdgeInsets.only(top: 32, left: 16, bottom: 16, right: 16),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            /// Your Filters
            Text(
              AppLocalizations.of(context)!.filters,
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(height: 32),

            /// The filters
            ..._filterService.filters.map(
              (filter) => GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (builder) => FilterPage(
                    filter: filter,
                    onDelete: () => setState(() => _filterService.removeFilter(filter)),
                  ),
                )),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Hero(
                          tag: filter.image,
                          child: FadeInImage(
                            image: NetworkImage(filter.image, scale: 10),
                            placeholder: const AssetImage('assets/preview_image.png'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              filter.name,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            const SizedBox(height: 4),
                            Text(AppLocalizations.of(context)!.aboutShort(
                              _spotifyService.playlists[filter.source]?.name ?? '',
                              _spotifyService.playlists[filter.target]?.name ?? '',
                            )),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            /// Warning if there are no filters
            Visibility(
              visible: _filterService.filters.isEmpty,
              child: Row(
                children: [
                  const Icon(Icons.info),
                  const SizedBox(width: 12),
                  Text(AppLocalizations.of(context)!.noFilters)
                ],
              ),
            )
          ],
        ),
      ),

      /// Add new filter
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
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
    );
  }
}
