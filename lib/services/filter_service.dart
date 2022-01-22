import 'dart:convert';

import 'package:genreator/models/general/filter_model.dart';
import 'package:genreator/models/general/playlist_info_model.dart';
import 'package:genreator/services/spotify_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility.dart';

class FilterService {
  /// Private constructor for singleton
  FilterService._privateConstructor();

  /// Factory constructor returns the singleton instance
  factory FilterService() => _instance;

  /// The singleton instance
  static final FilterService _instance = FilterService._privateConstructor();

  /// The key for the filters (used for shared preferences)
  static const _filtersKey = 'filters';

  /// The existing filters
  final _filters = <FilterModel>[];

  /// The spotify service
  final _spotifyService = SpotifyService();

  /// The existing filter models
  List<FilterModel> get filters {
    return _filters;
  }

  /// Initialize the filter service
  Future<void> init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonData = sharedPreferences.getString(_filtersKey);
    if (jsonData != null) jsonDecode(jsonData).forEach((filter) => _filters.add(FilterModel.fromJson(filter)));
  }

  /// Adds a new filter
  void addFilter(FilterModel filter) {
    _filters.add(filter);
    save();
  }

  /// Removes a filter
  void removeFilter(FilterModel filter) {
    _filters.remove(filter);
    save();
  }

  /// Saves the current filters
  Future<void> save() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_filtersKey, jsonEncode(_filters));
  }

  /// Run a [filter] with a given [playlistInfo] of the source playlist
  Future<void> run(FilterModel filter, PlaylistInfoModel playlistInfo) async {
    // Save and run the filter
    save();
    final filteredTracks = filter.applyFilter(playlistInfo).map((track) => track.uri).toList();
    final filteredTracksSet = Set<String>.from(filteredTracks);

    // Load the tracks of the target playlist
    final apiTracks = await _spotifyService.loadTracks(filter.target);
    final targetTracks = apiTracks.map((track) => track.track?.uri ?? '');
    final targetTracksSet = Set<String>.from(targetTracks);

    // Remove unwanted songs
    if (filter.clearBefore) {
      final tracksToBeDeleted = targetTracksSet.where((track) => !filteredTracksSet.contains(track)).toList();
      final success = await _spotifyService.removeTracks(filter.target, tracksToBeDeleted);
      if (!success) showSnackBar(translation().failedToClear);
    }

    // Add the tracks
    final tracksToBeAdded = filteredTracksSet.where((track) => !targetTracksSet.contains(track)).toList();
    final success = await _spotifyService.addTracks(filter.target, tracksToBeAdded);
    showSnackBar(
      success ? translation().successfullyAdded : translation().failedToAdd,
    );

    // Reload the playlist
    await _spotifyService.loadPlaylists();
  }
}
