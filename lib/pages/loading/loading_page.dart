import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:genreator/services/filter_service.dart';
import 'package:genreator/services/spotify_service.dart';

import '../../navigator.dart';

class LoadingPage extends StatefulWidget {
  /// Constructor
  const LoadingPage({Key? key}) : super(key: key);

  /// Initialize state
  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with SingleTickerProviderStateMixin {
  /// The spotify service
  final SpotifyService _spotifyService = SpotifyService();

  /// The filter service
  final FilterService _filterService = FilterService();

  /// True if the spotify service had problems initializing
  var _error = false;

  /// The animation controller for the logo
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 3000),
    vsync: this,
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

  /// Initialize the state
  @override
  void initState() {
    // Initialize the state
    super.initState();

    // Start the animation
    _controller.forward();

    // Initialize spotify service and show the loading screen for at least 2 seconds
    final start = DateTime.now();
    _filterService.init().then((_) => _spotifyService.init().then((success) {
          if (success) {
            Future.delayed(Duration(milliseconds: 2000 - DateTime.now().millisecond - start.millisecond), () {
              Navigator.pushNamed(context, Routes.home);
            });
          } else {
            _controller.reset();
            _controller.stop();
            setState(() => _error = true);
          }
        }));
  }

  /// Dispose the animation controller
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  /// Build the layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RotationTransition(
                turns: CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
                child: const Image(
                  image: AssetImage('assets/icon.png'),
                  filterQuality: FilterQuality.high,
                )),
            Visibility(
                visible: _error,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error,
                        color: Theme.of(context).errorColor,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: Text(
                          AppLocalizations.of(context)!.loadingError,
                          style: TextStyle(color: Theme.of(context).errorColor),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
