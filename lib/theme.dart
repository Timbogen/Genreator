import 'package:flutter/material.dart';

class GenColors {
  /// The classic spotify green
  static const green = Color(0xFF1DB954);
  /// White for text etc.
  static const white = Color(0xFFFFFFFF);
  /// White for text etc.
  static const lightGrey = Color(0xA1FFFFFF);
  /// Black for background
  static const black = Color(0xFF191414);
  /// Grey tone for cards etc.
  static const grey = Color(0xFF3B3232);
  /// Red for errors
  static const red = Color(0xFFB91D1D);
}

/// Returns the app's theme
ThemeData genTheme() {
  return ThemeData(
    scaffoldBackgroundColor: GenColors.black,
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
      headline3: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      headline4: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      bodyText1: TextStyle(fontSize: 14.0),
      bodyText2: TextStyle(fontSize: 12.0),
    ).apply(
      bodyColor: GenColors.lightGrey,
      displayColor: GenColors.white,
    ),
    colorScheme: const ColorScheme(
      primary: GenColors.green,
      primaryVariant: GenColors.green,
      secondary: GenColors.green,
      secondaryVariant: GenColors.green,
      surface: GenColors.grey,
      background: GenColors.black,
      error: GenColors.red,
      onPrimary: GenColors.white,
      onSecondary: GenColors.white,
      onSurface: GenColors.white,
      onBackground: GenColors.white,
      onError: GenColors.white,
      brightness: Brightness.dark,
    ),
  );
}
