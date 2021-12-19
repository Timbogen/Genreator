import 'package:flutter/material.dart';

import '../theme.dart';
import '../utility.dart';
import '../widgets/header_widget.dart';

class FilterListPage extends StatefulWidget {
  /// The title of the page
  final String title;

  /// The list containing all items
  final List<String> items;

  /// The set of the included items
  final Set<String> includedItems;

  /// Constructor
  const FilterListPage({Key? key, required this.title, required this.items, required this.includedItems})
      : super(key: key);

  /// Create the state
  @override
  _FilterListPageState createState() => _FilterListPageState();
}

class _FilterListPageState extends State<FilterListPage> {
  /// Placeholder for filtered items
  static const empty = SizedBox.shrink();

  /// The controller for the search field
  final _textController = TextEditingController();

  /// True if all visible items are triggered
  var _allTriggered = false;

  /// True if only triggered items shall be shown
  var _onlyShowTriggered = false;

  /// The filter string
  var _filter = '';

  /// The list containing all items in alphabetical order
  var _items = <String>[];

  /// Sort the list
  @override
  void initState() {
    super.initState();
    _items = widget.items;
    _items.sort();
  }

  /// Returns true if a given item is visible
  bool _isItemVisible(String item) {
    var displayName = item;
    var itemTriggered = widget.includedItems.contains(item);
    var passesFilter = displayName.toLowerCase().contains(_filter.toLowerCase());
    return passesFilter && (!_onlyShowTriggered || itemTriggered);
  }

  /// Triggers all visible items
  void _triggerAll() {
    for (var item in _items) {
      // Check if item is visible
      if (!_isItemVisible(item)) continue;

      // Trigger the item
      if (_allTriggered) {
        widget.includedItems.remove(item);
      } else {
        widget.includedItems.add(item);
      }
    }
    setState(() => _allTriggered = !_allTriggered);
  }

  /// Build the layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget(title: widget.title),
      body: Column(
        children: [
          /// The search bar
          Padding(
            padding: defaultPadding,
            child: TextField(
              controller: _textController,
              onChanged: (text) => setState(() {
                _filter = text;
                _allTriggered = false;
              }),
              decoration: InputDecoration(
                fillColor: GenColors.grey,
                filled: true,
                prefixIcon: const Icon(Icons.search, color: GenColors.lightGrey),
                hintText: translation().search,
                contentPadding: const EdgeInsets.all(16),
                suffixIcon: _filter.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          setState(() => _filter = '');
                          _textController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
            ),
          ),

          /// Only show triggered
          Padding(
            padding: sidePadding,
            child: Row(
              children: [
                Text(translation().onlyShowTriggered, style: const TextStyle(fontSize: 14.0)),
                const Spacer(),
                Checkbox(
                  value: _onlyShowTriggered,
                  onChanged: (_) => setState(() {
                    _onlyShowTriggered = !_onlyShowTriggered;
                    _allTriggered = false;
                  }),
                )
              ],
            ),
          ),

          /// Trigger all
          Padding(
            padding: sidePadding,
            child: Row(
              children: [
                Text(translation().triggerVisible, style: const TextStyle(fontSize: 14.0)),
                const Spacer(),
                Checkbox(
                  value: _allTriggered,
                  onChanged: (_) => _triggerAll(),
                )
              ],
            ),
          ),

          /// The list
          Expanded(
            child: ListView.builder(
                padding: defaultPadding,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  /// Check if item should be shown
                  if (!_isItemVisible(_items[index])) return empty;

                  /// Show the item
                  var itemTriggered = widget.includedItems.contains(_items[index]);
                  return Row(
                    children: [
                      Expanded(
                          child: Text(
                        _items[index],
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14.0, color: GenColors.white),
                      )),
                      Checkbox(
                        value: itemTriggered,
                        onChanged: (_) => setState(() => itemTriggered
                            ? widget.includedItems.remove(_items[index])
                            : widget.includedItems.add(_items[index])),
                      )
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}
