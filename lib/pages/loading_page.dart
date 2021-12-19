import 'package:flutter/material.dart';

import '../theme.dart';
import '../utility.dart';

/// Create a controller for the gen icon loading animation
AnimationController genAnimationController(TickerProvider tickerProvider) {
  var controller = AnimationController(
    duration: const Duration(milliseconds: 3000),
    vsync: tickerProvider,
  );
  controller.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      controller.reverse();
    } else if (status == AnimationStatus.dismissed) {
      controller.forward();
    }
  });
  return controller;
}

class LoadingPage extends StatefulWidget {
  /// The workload that has to be finished
  final Function(Function(double)) workload;

  /// The callback that is called when the work is done
  final Function(BuildContext) onFinish;

  /// True if the progress shall be shown
  final bool showProgress;

  /// Constructor
  const LoadingPage({Key? key, required this.workload, required this.onFinish, this.showProgress = false})
      : super(key: key);

  /// Initialize state
  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with SingleTickerProviderStateMixin {
  /// The animation controller for the logo
  late final AnimationController _controller = genAnimationController(this);

  /// The progress of the loading workload
  double _progress = 0.0;

  /// Initialize the state
  @override
  void initState() {
    super.initState();

    // Start the animation
    _controller.forward();

    // Process the workload but make sure that the loading spinner is visible for
    // at least 2 seconds
    final start = DateTime.now();
    Future(() async {
      try {
        await widget.workload((progress) => setState(() => _progress = progress));
        Future.delayed(
          Duration(milliseconds: 2000 - DateTime
              .now()
              .millisecond - start.millisecond),
              () => widget.onFinish(context),
        );
      } catch (e) {
        _controller.reset();
        _controller.stop();
        showSnackBar(e.toString(), duration: const Duration(days: 1));
      }
    });
  }

  /// Dispose the animation controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Build the layout
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /// The genreator icon
              RotationTransition(
                turns: CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
                child: const Image(
                  image: AssetImage('assets/icon.png'),
                  filterQuality: FilterQuality.high,
                ),
              ),

              /// The progress bar
              Visibility(
                visible: widget.showProgress,
                child: Padding(
                  padding: const EdgeInsets.all(paddingBig),
                  child: Column(
                    children: [
                      const SizedBox(height: 48),
                      LinearProgressIndicator(value: _progress),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
