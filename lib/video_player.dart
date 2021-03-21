import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:video_player/video_player.dart';

enum SciVideoPlayerStatus {
  idle,
  initializing,
  initialized,
  playing,
  paused,
  completed,
  error,
}

class SciVideoPlayerController extends VideoPlayerController {
  SciVideoPlayerController.asset(
    String dataSource, {
    String package,
    Future<ClosedCaptionFile> closedCaptionFile,
    VideoPlayerOptions videoPlayerOptions,
    this.autoPlay = true,
    this.startPosition = Duration.zero,
  }) : super.asset(
          dataSource,
          package: package,
          closedCaptionFile: closedCaptionFile,
          videoPlayerOptions: videoPlayerOptions,
        );

  SciVideoPlayerController.network(
    String dataSource, {
    VideoFormat formatHint,
    Future<ClosedCaptionFile> closedCaptionFile,
    VideoPlayerOptions videoPlayerOptions,
    this.autoPlay = true,
    this.startPosition = Duration.zero,
  }) : super.network(
          dataSource,
          formatHint: formatHint,
          closedCaptionFile: closedCaptionFile,
          videoPlayerOptions: videoPlayerOptions,
        );

  SciVideoPlayerController.file(
    File file, {
    Future<ClosedCaptionFile> closedCaptionFile,
    VideoPlayerOptions videoPlayerOptions,
    this.autoPlay = true,
    this.startPosition = Duration.zero,
  }) : super.file(
          file,
          closedCaptionFile: closedCaptionFile,
          videoPlayerOptions: videoPlayerOptions,
        );

  final bool autoPlay;
  final Duration startPosition;

  StreamController<SciVideoPlayerStatus> _statusStreamController =
      StreamController.broadcast();
  bool _isSeeking = false;

  bool get isSeeking => _isSeeking;

  Stream<SciVideoPlayerStatus> get onStatusChanged =>
      _statusStreamController.stream.distinct();

  @override
  Future<void> seekTo(Duration position) async {
    if (position >= value.duration) {
      position = Duration(seconds: value.duration.inSeconds);
    }
    _isSeeking = true;
    notifyListeners();
    await pause();
    await super.seekTo(position);
    await play();
    _isSeeking = false;
    notifyListeners();
  }
}

class SciVideoPlayer extends StatefulWidget {
  SciVideoPlayer(
    this.controller, {
    this.onPositionChange,
    this.onControlShowOrHide,
    this.onStatusChange,
  });

  final SciVideoPlayerController controller;
  final void Function(Duration, Duration) onPositionChange;
  final void Function(bool) onControlShowOrHide;
  final void Function(SciVideoPlayerStatus) onStatusChange;

  @override
  _SciVideoPlayerState createState() => _SciVideoPlayerState();
}

class _SciVideoPlayerState extends State<SciVideoPlayer> {
  @override
  void initState() {
    super.initState();
    widget.controller.onStatusChanged
        .listen((status) => widget.onStatusChange?.call(status));

    if (widget.controller.value.initialized) {
      widget.controller._statusStreamController
          .add(SciVideoPlayerStatus.initialized);
      if (widget.controller.autoPlay) {
        widget.controller.play().then((value) => setState(() {}));
      }
    } else {
      widget.controller._statusStreamController
          .add(SciVideoPlayerStatus.initializing);
      widget.controller.initialize().then((value) {
        widget.controller._statusStreamController
            .add(SciVideoPlayerStatus.initialized);
        if (widget.controller.autoPlay) {
          widget.controller.play().then((value) => setState(() {}));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: AspectRatio(
          aspectRatio: widget.controller.value.initialized
              ? widget.controller.value.aspectRatio
              : 1,
          child: Stack(
            children: [
              VideoPlayer(widget.controller),
              _SciVideoPlayerControl(
                widget.controller,
                onPositionChange: widget.onPositionChange,
                onControlShowOrHide: widget.onControlShowOrHide,
                onStatusChange: widget.onStatusChange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SciVideoPlayerControl extends StatefulWidget {
  _SciVideoPlayerControl(
    this.controller, {
    this.onPositionChange,
    this.onControlShowOrHide,
    this.onStatusChange,
  });

  final SciVideoPlayerController controller;
  final void Function(Duration, Duration) onPositionChange;
  final void Function(bool) onControlShowOrHide;
  final void Function(SciVideoPlayerStatus) onStatusChange;

  @override
  __SciVideoPlayerControlState createState() => __SciVideoPlayerControlState();
}

class __SciVideoPlayerControlState extends State<_SciVideoPlayerControl> {
  var _show = true;
  var _isInitialized = false;
  var _isBuffering = false;
  var _bufferedValue = 0.0;
  var _progressValue = 0.0;
  var _position = Duration.zero;
  var _duration = Duration.zero;
  var _isDragging = false;
  var _isPlaying = false;
  var _isCompleted = false;
  Timer _hideTimer;
  var _horizontalDragPosition = Duration.zero;
  var _verticalDragDelta = 0.0;
  var _willSeekToHintText = '';
  DateTime _lastSliderChangeEndTime;

  bool get _showLoading => !_isInitialized || _isBuffering;

  double get sliderBottomMargin {
    final screenWidth = MediaQueryData.fromWindow(window).size.width;
    final screenHeight = MediaQueryData.fromWindow(window).size.height;
    final safeAreaBottom = MediaQueryData.fromWindow(window).padding.bottom;
    final screenRatio = screenWidth / screenHeight;
    final aspectRatio = widget.controller.value.aspectRatio;
    double width;
    double height;
    if (screenRatio < aspectRatio) {
      width = screenWidth;
      height = width / aspectRatio;
    } else {
      height = screenHeight;
      width = height * aspectRatio;
    }
    return max(safeAreaBottom - (screenHeight - height) / 2, 0.0) + 10;
  }

  void _startHideTimer() {
    _stopHideTimer();
    _hideTimer = Timer.periodic(
      Duration(seconds: 5),
      (timer) {
        setState(() => _show = false);
        widget.onControlShowOrHide?.call(_show);
        _stopHideTimer();
      },
    );
  }

  void _stopHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = null;
  }

  void _listener() {
    if (widget.controller.value.hasError) {
      widget.controller._statusStreamController.add(SciVideoPlayerStatus.error);
      return;
    }
    _isInitialized = widget.controller.value.initialized;
    final previousPosition = _position;
    final previousDuration = _duration;
    _position = widget.controller.value.position;
    _duration = widget.controller.value.duration;
    if (previousPosition != _position || previousDuration != _duration) {
      widget.onPositionChange?.call(_position, _duration);
    }
    final buffered = widget.controller.value.buffered;
    _isBuffering = widget.controller.value.isBuffering ||
        widget.controller.isSeeking ||
        buffered.isEmpty ||
        (buffered.last.end < _position + Duration(seconds: 3) &&
            buffered.last.end < _duration - Duration(milliseconds: 200));
    if (buffered.isNotEmpty) {
      _bufferedValue =
          buffered.first.end.inMilliseconds / _duration.inMilliseconds;
    }
    if (!_isDragging && _duration > Duration.zero) {
      _progressValue = _position.inMilliseconds
          .toDouble()
          .clamp(0, _duration.inMilliseconds.toDouble());
    }
    _isPlaying = widget.controller.value.isPlaying;
    _isCompleted = _position >= _duration;
    if (_isInitialized) {
      if (_isCompleted) {
        widget.controller._statusStreamController
            .add(SciVideoPlayerStatus.completed);
      } else if (_isPlaying) {
        widget.controller._statusStreamController
            .add(SciVideoPlayerStatus.playing);
      } else {
        widget.controller._statusStreamController
            .add(SciVideoPlayerStatus.paused);
      }
    }
    setState(() {});
    // debugPrint(
    //     '[Video Value]: ${widget.controller.value} position=$_position, duration=$_duration, isBuffering=$_isBuffering, buffered=${buffered} -> ${_position.inMilliseconds / _duration.inMilliseconds} $_bufferedValue');
  }

  @override
  void initState() {
    super.initState();
    _startHideTimer();
    _isInitialized = widget.controller.value.initialized;
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _show = !_show);
        widget.onControlShowOrHide?.call(_show);
        if (_show) {
          _startHideTimer();
        } else {
          _stopHideTimer();
        }
      },
      onDoubleTap: _playOrPause,
      onHorizontalDragStart: (details) {
        _horizontalDragPosition = _position;
        debugPrint('onHorizontalDragStart: $details');
      },
      onHorizontalDragUpdate: (details) {
        _horizontalDragPosition +=
            Duration(milliseconds: (details.delta.dx * 500).toInt());
        if (_horizontalDragPosition >= _duration)
          _horizontalDragPosition = Duration(seconds: _duration.inSeconds);
        _willSeekToHintText =
            '${_timeText(_horizontalDragPosition)} / ${_timeText(_duration)}';
        setState(() {});
      },
      onHorizontalDragEnd: (details) {
        _willSeekToHintText = '';
        debugPrint('onHorizontalDragEnd: $_duration, $_horizontalDragPosition');
        widget.controller.seekTo(_horizontalDragPosition);
      },
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            if (_showLoading)
              Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            if (_show)
              Stack(
                children: [
                  if (!_showLoading)
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _startHideTimer();
                              widget.controller
                                  .seekTo(_position - Duration(seconds: 10));
                            },
                            child: Image.asset(
                              'assets/back_ten.png',
                              scale: 3,
                            ),
                          ),
                          SizedBox(width: 64),
                          GestureDetector(
                            onTap: () {
                              _startHideTimer();
                              _playOrPause();
                            },
                            child: Image.asset(
                              _isPlaying
                                  ? 'assets/pause_big.png'
                                  : 'assets/play_big.png',
                              scale: 3,
                            ),
                          ),
                          SizedBox(width: 64),
                          GestureDetector(
                            onTap: () {
                              _startHideTimer();
                              widget.controller
                                  .seekTo(_position + Duration(seconds: 10));
                            },
                            child: Image.asset(
                              'assets/forward_ten.png',
                              scale: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_isInitialized)
                    Positioned(
                      bottom: sliderBottomMargin,
                      left: 20,
                      right: 20,
                      child: Container(
                        height: 40,
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _startHideTimer();
                                _playOrPause();
                              },
                              child: SizedBox(
                                width: 24,
                                child: Image.asset(
                                  _isPlaying
                                      ? 'assets/pause.png'
                                      : 'assets/play.png',
                                  scale: 3,
                                ),
                              ),
                            ),
                            _buildTimeLabel(_position),
                            Expanded(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0),
                                    child: LinearProgressIndicator(
                                      backgroundColor: Colors.transparent,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.black.withOpacity(0.5)),
                                      value: _bufferedValue,
                                      minHeight: 4,
                                    ),
                                  ),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Colors.white,
                                      inactiveTrackColor:
                                          Colors.white.withOpacity(0.2),
                                      thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 6,
                                        disabledThumbRadius: 8,
                                      ),
                                      thumbColor: Colors.white,
                                      trackHeight: 4,
                                    ),
                                    child: SciSlider(
                                      value: _progressValue,
                                      min: 0,
                                      max: _duration.inMilliseconds.toDouble(),
                                      divisions: max(_duration.inSeconds, 1),
                                      label: _timeText(
                                        Duration(
                                          milliseconds: _progressValue.toInt(),
                                        ),
                                      ),
                                      onChangeStart: (value) {
                                        if (DateTime.now().difference(
                                                _lastSliderChangeEndTime ??
                                                    DateTime(1970)) <
                                            Duration(milliseconds: 100)) return;
                                        _lastSliderChangeEndTime = null;
                                        _stopHideTimer();
                                        _isDragging = true;
                                        // _progressValue = value;
                                        setState(() {});
                                      },
                                      onChanged: (value) {
                                        _isDragging = true;
                                        _progressValue = value;
                                        setState(() {});
                                      },
                                      onChangeEnd: (value) async {
                                        if (_lastSliderChangeEndTime != null)
                                          return;
                                        _lastSliderChangeEndTime =
                                            DateTime.now();
                                        _progressValue =
                                            value.toInt().toDouble();
                                        await widget.controller.seekTo(Duration(
                                            milliseconds: value.toInt()));
                                        _isDragging = false;
                                        _startHideTimer();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildTimeLabel(_duration),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            if (_willSeekToHintText.isNotEmpty)
              Center(
                child: Container(
                  width: 150,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _willSeekToHintText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildTimeLabel(Duration duration) {
    return SizedBox(
      width: 50,
      child: Center(
        child: Text(
          _timeText(duration),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  String _timeText(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    if (hours == 0) {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  void _playOrPause() {
    if (_isCompleted) {
      widget.controller.seekTo(Duration.zero);
    } else if (_isPlaying) {
      widget.controller.pause();
    } else {
      widget.controller.play();
    }
  }
}

/// FIX: Slider notifies "onChangeStart" and "onChangeEnd" twice error => https://github.com/flutter/flutter/issues/28115
class SciSlider extends StatefulWidget {
  SciSlider({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = false,
  }) : super(key: key);

  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;
  final double min;
  final double max;
  final int divisions;
  final String label;
  final Color activeColor;
  final Color inactiveColor;
  final MouseCursor mouseCursor;
  final SemanticFormatterCallback semanticFormatterCallback;
  final FocusNode focusNode;
  final bool autofocus;

  @override
  _SciSliderState createState() => _SciSliderState();
}

class _SciSliderState extends State<SciSlider> {
  static const _duration = Duration(milliseconds: 100);
  DateTime _lastOnChangeEnd = DateTime(1970);
  Timer _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: widget.value,
      onChanged: widget.onChanged,
      onChangeStart: (details) {
        if (DateTime.now().difference(_lastOnChangeEnd) > _duration) {
          widget.onChangeStart?.call(details);
        } else {
          _timer?.cancel();
        }
      },
      onChangeEnd: (details) {
        _lastOnChangeEnd = DateTime.now();
        _delayOnChangeEnd(() {
          widget.onChangeEnd?.call(details);
        });
      },
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
      label: widget.label,
      activeColor: widget.activeColor,
      inactiveColor: widget.inactiveColor,
      mouseCursor: widget.mouseCursor,
      semanticFormatterCallback: widget.semanticFormatterCallback,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
    );
  }

  void _delayOnChangeEnd(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(_duration, action);
  }
}
