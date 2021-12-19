import 'package:flutter/material.dart';

/// The default padding sizes
const paddingBig = 24.0;
const paddingSmall = 16.0;
const defaultPadding = EdgeInsets.symmetric(vertical: paddingSmall, horizontal: paddingBig);
const sidePadding = EdgeInsets.symmetric(horizontal: paddingBig);

/// The colors
class GenColors {
  /// The classic spotify green
  static const green = Color(0xFF1DB954);
  /// White for text etc.
  static const white = Color(0xFFFFFFFF);
  /// White for text etc.
  static const lightGrey = Color(0xFFB9B9B9);
  /// Black for background
  static const black = Color(0xFF191414);
  /// Grey tone for cards etc.
  static const grey = Color(0xFF413B3B);
  /// Red for errors
  static const red = Color(0xFFB91D1D);
}

/// Returns the app's theme
ThemeData genTheme() {
  return ThemeData(
    scaffoldBackgroundColor: GenColors.black,
    canvasColor: GenColors.black,
    toggleableActiveColor: GenColors.green,
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
      headline3: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      headline4: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      headline5: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: GenColors.lightGrey),
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
      background: GenColors.grey,
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
