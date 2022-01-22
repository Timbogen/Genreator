import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:genreator/theme.dart';

/// Global key for using common services without the need of having
/// access to the current context
final GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey<ScaffoldMessengerState>();

/// String extension
extension CapExtension on String {
  /// Capitalizes first character of a string
  String get capitalizeWord => '${this[0].toUpperCase()}${length > 1 ? substring(1) : ''}';

  /// Capitalizes the first character of every word
  String get capitalizeSentence => split(' ').map((str) => str.capitalizeWord).join(' ');
}

/// Shows snack bar
void showSnackBar(String text, {Duration duration = const Duration(seconds: 5)}) {
  globalKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(text),
      duration: duration,
    ),
  );
}

/// Provides access to the translations
AppLocalizations translation() {
  return AppLocalizations.of(globalKey.currentContext!)!;
}

/// Confirm dialog
void showConfirmDialog(BuildContext context, String title, String description, Function onConfirm) {
  // Cancel button
  Widget cancelButton = TextButton(
    child: Text(translation().cancel),
    onPressed: () => Navigator.of(context).pop(),
  );

  // Confirm button
  Widget continueButton = ElevatedButton(
    onPressed: () {
      Navigator.of(context).pop();
      onConfirm();
    },
    child: Text(translation().confirm),
  );

  // Prepare the dialog
  var alert = AlertDialog(
    title: Text(title),
    backgroundColor: GenColors.grey,
    content: Text(description),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
