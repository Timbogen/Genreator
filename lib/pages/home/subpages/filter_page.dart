import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:genreator/models/general/filter_model.dart';
import 'package:genreator/pages/home/widgets/header_widget.dart';
import 'package:genreator/services/spotify_service.dart';

import '../../../theme.dart';

class FilterArguments {
  /// Constructor
  FilterArguments();
}

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
  final SpotifyService _spotifyService = SpotifyService();

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
            HeaderWidget(title: widget.filter.name),

            /// Name
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: widget.filter.image,
                  child: Image(image: NetworkImage(widget.filter.image, scale: 4)),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Card(
                color: GenColors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// About filter
                      Text(
                        AppLocalizations.of(context)!.aboutFilter,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.aboutLong(
                          _spotifyService.playlists[widget.filter.source]?.name ?? '',
                          _spotifyService.playlists[widget.filter.target]?.name ?? '',
                        ),
                      ),
                      const SizedBox(height: 32),

                      /// Start filter
                      Text(
                        AppLocalizations.of(context)!.startFilter,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.startDescription,
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// Delete filter
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.deleteFilter,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.onDelete();
                            Navigator.of(context).pop();
                          },
                          child: Text(AppLocalizations.of(context)!.delete),
                          style: ElevatedButton.styleFrom(primary: GenColors.red),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.deleteFilterDescription,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// Run the filter
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.play_arrow),
        onPressed: () => print("test"),
      ),
    );
  }
}
