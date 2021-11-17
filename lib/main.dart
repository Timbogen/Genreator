import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:genreator/navigator.dart';
import 'package:genreator/theme.dart';
import 'package:global_configuration/global_configuration.dart';

/// Start the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await GlobalConfiguration().loadFromAsset('config');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  /// Constructor
  const MyApp({Key? key}) : super(key: key);

  /// Create the material app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genreator',
      theme: genTheme(),
      initialRoute: Routes.loading,
      routes: genNavigator(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
