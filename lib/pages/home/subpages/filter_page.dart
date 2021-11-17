import 'package:flutter/material.dart';
import 'package:genreator/models/general/filter_model.dart';
import 'package:genreator/pages/home/widgets/header_widget.dart';

class FilterArguments {
  /// Constructor
  FilterArguments();
}

class FilterPage extends StatefulWidget {
  /// The inspected filter
  final FilterModel filter;

  /// Constructor
  const FilterPage({Key? key, required this.filter})
      : super(key: key);

  /// Initialize state
  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
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
            Hero(
              tag: widget.filter.image,
              child: Image(image: NetworkImage(widget.filter.image, scale: 5)),
            ),
          ],
        ),
      ),
    );
  }
}
