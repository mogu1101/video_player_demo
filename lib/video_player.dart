import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

enum VideoPlayerStatus {
  idle,
  initialized,
  preparing,
  prepared,
  playing,
  paused,
  completed,
  error,
}

abstract class VideoPlayerProvider {
  Duration get position;

  Duration get duration;

  VideoPlayerStatus get status;

  bool get isBuffering;

  Future<void> play();

  Future<void> pause();

  Future<void> dispose();

  Stream<Duration> get onPositionChanged;

  Stream<bool> get onControlShowOrHide;

  Stream<void> get onForwardClick;

  Stream<void> get onBackClick;
}

abstract class EmptyMixin {}

class SciVideoPlayerController = VideoPlayerController with EmptyMixin;

class SciVideoPlayerViewModel extends ChangeNotifier {
  SciVideoPlayerViewModel(this.controller);

  final SciVideoPlayerController controller;



  void init() {
    controller.initialize().then((value) => controller.play());
    controller.addListener(() {

    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class SciVideoPlayer extends StatelessWidget {
  SciVideoPlayer(this.controller);

  final SciVideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider(create: ,)
    return Stack(
      children: [
        VideoPlayer(controller),
      ],
    );
  }
}
