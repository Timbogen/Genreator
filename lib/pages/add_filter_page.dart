import 'package:flutter/material.dart';
import 'package:genreator/models/general/filter_model.dart';
import 'package:genreator/theme.dart';
import 'package:genreator/widgets/header_button_widget.dart';

import '../utility.dart';
import '../widgets/header_widget.dart';

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
  /// Returns the confirm callback or null if the filter isn't correct
  VoidCallback? _confirm() {
    if (widget.filter.name != '') {
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
      /// Header
      appBar: HeaderWidget(
        title: translation().addFilter,
        actions: [
          // Confirm button
          HeaderButtonWidget(
            icon: Icons.check,
            onPressed: _confirm(),
          ),
        ],
      ),

      /// Content
      body: Padding(
        padding: defaultPadding,
        child: TextField(
          autofocus: true,
          onChanged: (text) => setState(() => widget.filter.name = text),
          decoration: InputDecoration(
            fillColor: GenColors.grey,
            filled: true,
            hintText: translation().name,
          ),
        ),
      ),
    );
  }
}
