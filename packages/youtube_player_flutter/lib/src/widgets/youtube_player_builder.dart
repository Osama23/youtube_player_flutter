import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// A wrapper for [YoutubePlayer].
class YoutubePlayerBuilder extends StatefulWidget {
  /// The actual [YoutubePlayer].
  final YoutubePlayer player;

  /// Builds the widget below this [builder].
  final Widget Function(BuildContext, Widget) builder;

  /// Callback to notify that the player has entered fullscreen.
  final VoidCallback? onEnterFullScreen;

  /// Callback to notify that the player has exited fullscreen.
  final VoidCallback? onExitFullScreen;

  /// widet for the email
  final Widget textAnimation;

  /// Builder for [YoutubePlayer] that supports switching between fullscreen and normal mode.
  const YoutubePlayerBuilder({
    Key? key,
    required this.player,
    required this.builder,
    this.onEnterFullScreen,
    this.onExitFullScreen,
    required this.textAnimation,
  }) : super(key: key);

  @override
  _YoutubePlayerBuilderState createState() => _YoutubePlayerBuilderState();
}

class _YoutubePlayerBuilderState extends State<YoutubePlayerBuilder>
    with WidgetsBindingObserver {
  final GlobalKey playerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final physicalSize = SchedulerBinding.instance?.window.physicalSize;
    final controller = widget.player.controller;
    if (physicalSize != null && physicalSize.width > physicalSize.height) {
      controller.updateValue(controller.value.copyWith(isFullScreen: true));
      SystemChrome.setEnabledSystemUIOverlays([]);
      widget.onEnterFullScreen?.call();
    } else {
      controller.updateValue(controller.value.copyWith(isFullScreen: false));
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      widget.onExitFullScreen?.call();
    }
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    final _player = Container(
      key: playerKey,
      child: WillPopScope(
        onWillPop: () async {
          final controller = widget.player.controller;
          if (controller.value.isFullScreen) {
            widget.player.controller.toggleFullScreenMode();
            return false;
          }
          return true;
        },
        child: Stack(children: [
          widget.player,
          Container(
            margin: const EdgeInsets.only(top: 40),
            height: 20,
            width: double.infinity,
            child: widget.textAnimation,
          ),
          // Column(
          //   children: [
          //     widget.player,
          //     // Container(
          //     //   margin: const EdgeInsets.only(top: 40),
          //     //   height: 20,
          //     //   width: double.infinity,
          //     //   child: widget.textAnimation,
          //     // ),
          //   ],
          // ),

          // Positioned(
          //   bottom: 30,
          //   child: Container(
          //     height: 20,
          //     width: double.infinity,
          //     child: widget.textAnimation,
          //   ),
          // ),
        ]),
      ),
    );
    final child = widget.builder(context, _player);
    return OrientationBuilder(
      builder: (context, orientation) =>
          orientation == Orientation.portrait ? child : _player,
    );
  }
}
