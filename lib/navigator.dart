import 'package:flutter/material.dart';

import 'pages/home/home_page.dart';
import 'pages/loading/loading_page.dart';

/// The possible routes
class Routes {
  /// The route that leads to the loading screen
  static const loading = "/loading";

  /// The route that leads to the home screen
  static const home = "/home";
}

/// Returns the navigator
Map<String, WidgetBuilder> genNavigator() {
  return {
    Routes.loading: (context) => const LoadingPage(),
    Routes.home: (context) => const HomePage(),
  };
}