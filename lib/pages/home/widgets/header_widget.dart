import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  /// The title
  final String title;

  /// Constructor
  const HeaderWidget({Key? key, required this.title}) : super(key: key);

  /// Build the layout
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: IconButton(
                padding: const EdgeInsets.all(0.0),
                icon: const Icon(Icons.arrow_back, size: 24),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Text(title, style: Theme.of(context).textTheme.headline2),
            const SizedBox(width: 24)
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
