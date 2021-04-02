import 'package:flutter/material.dart';

import '../enums/thumbnail_quality.dart';
import '../utils/youtube_player_controller.dart';

// ignore: public_member_api_docs
class PlaybackQualityButton extends StatefulWidget {
  /// Overrides the default [YoutubePlayerController].
  final YoutubePlayerController? controller;

  /// Defines icon for the button.
  final Widget? icon;

  /// Creates [PlaybackQualityButton] widget.
  const PlaybackQualityButton({
    this.controller,
    this.icon,
  });

  @override
  _PlaybackQualityButtonState createState() => _PlaybackQualityButtonState();
}

class _PlaybackQualityButtonState extends State<PlaybackQualityButton> {
  late YoutubePlayerController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = YoutubePlayerController.of(context);
    if (controller == null) {
      assert(
        widget.controller != null,
        '\n\nNo controller could be found in the provided context.\n\n'
        'Try passing the controller explicitly.',
      );
      _controller = widget.controller!;
    } else {
      _controller = controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: _controller.setPlaybackQuality,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
        child: widget.icon ??
            Image.asset(
              'assets/speedometer.webp',
              package: 'youtube_player_flutter',
              width: 20.0,
              height: 20.0,
              color: Colors.white,
            ),
      ),
      tooltip: 'PlayBack Qualit',
      itemBuilder: (context) => [
        _popUpItem('720', ThumbnailQuality.max),
        _popUpItem('640', ThumbnailQuality.standard),
        _popUpItem('480', ThumbnailQuality.high),
        _popUpItem('320', ThumbnailQuality.medium),
        _popUpItem('120', ThumbnailQuality.defaultQuality),
      ],
    );
  }

  PopupMenuEntry<String> _popUpItem(String text, String qauilty) {
    return CheckedPopupMenuItem(
      checked: _controller.value.playbackQuality == qauilty,
      child: Text(text),
      value: qauilty,
    );
  }
}
