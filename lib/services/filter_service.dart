import 'dart:convert';

import 'package:genreator/models/general/filter_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _save();
  }

  /// Removes a filter
  void removeFilter(FilterModel filter) {
    _filters.remove(filter);
    _save();
  }

  /// Saves the current filters
  Future<void> _save() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_filtersKey, jsonEncode(_filters));
  }
}
