import 'package:flutter/material.dart';

class ActionButtonWidget extends StatelessWidget {
  /// The icon
  final IconData icon;

  /// The text
  final String text;

  /// The callback
  final VoidCallback? onPressed;

  /// Constructor
  const ActionButtonWidget({Key? key, required this.icon, required this.text, this.onPressed}) : super(key: key);

  /// Build the layout
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      width: double.infinity,
      child: ElevatedButton.icon(
        label: Text(text),
        icon: Icon(icon, size: 24),
        onPressed: onPressed,
      ),
    );
  }
}
