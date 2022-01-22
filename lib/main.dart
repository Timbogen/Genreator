import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:genreator/pages/home_page.dart';
import 'package:genreator/pages/loading_page.dart';
import 'package:genreator/services/filter_service.dart';
import 'package:genreator/services/spotify_service.dart';
import 'package:genreator/theme.dart';
import 'package:genreator/utility.dart';
import 'package:global_configuration/global_configuration.dart';

/// Start the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await GlobalConfiguration().loadFromAsset('config');

  runApp(Genreator());
}

class Genreator extends StatelessWidget {
  /// The spotify service
  final SpotifyService _spotifyService = SpotifyService();

  /// The filter service
  final FilterService _filterService = FilterService();

  /// Constructor
  Genreator({Key? key}) : super(key: key);

  /// Create the material app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genreator',
      theme: genTheme(),
      home: LoadingPage(
        workload: (_) async {
          final success = await _spotifyService.init();
          if (!success) throw Exception(translation().loadingError);
          await _filterService.init();
        },
        onFinish: (context) => Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (builder) => const HomePage(),
        )),
      ),
      scaffoldMessengerKey: globalKey,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
