import 'package:flutter/material.dart';

class TitleDescriptionWidget extends StatelessWidget {
  /// The title
  final String title;

  /// The description
  final String description;

  /// Constructor
  const TitleDescriptionWidget({Key? key, required this.title, required this.description}) : super(key: key);

  /// Build the layout
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1000,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// The title
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: 8),

          /// The description
          Text(
            description,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
