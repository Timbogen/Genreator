import 'package:flutter/material.dart';

class HeaderButtonWidget extends StatelessWidget {
  /// The icon of the button
  final IconData icon;

  /// The action that is executed if the button is pressed
  final VoidCallback? onPressed;

  /// Constructor
  const HeaderButtonWidget({Key? key, required this.icon, this.onPressed}) : super(key: key);

  /// Build the layout
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: IconButton(
        padding: const EdgeInsets.all(0.0),
        icon: Icon(icon, size: 24),
        onPressed: onPressed,
      ),
    );
  }
}
