import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title = ''}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Text(
                '码率4Mbps',
                style: Theme.of(context).textTheme.headline6,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/guang.mp4')));
              },
            ),
            SizedBox(height: 20),
            GestureDetector(
              child: Text(
                '码率1Mbps',
                style: Theme.of(context).textTheme.headline6,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/guang_1m.mp4')));
              },
            ),
            SizedBox(height: 20),
            GestureDetector(
              child: Text(
                '码率512kbps',
                style: Theme.of(context).textTheme.headline6,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/guang_512k.mp4')));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPage extends StatefulWidget {
  VideoPage(this.url);

  final String url;

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;
  var _isDragging = false;
  var _progressValue = 0.0;
  var _bufferedValue = 0.0;

  var duration = Duration.zero;
  var position = Duration.zero;
  List<DurationRange> buffered = [];
  bool isBuffering = false;

  @override
  void initState() {
    super.initState();
    final url = widget.url;
    _controller = VideoPlayerController.network(url)
      ..initialize().then((value) {
        _controller.play();
        setState(() {});
      });
    _controller.addListener(() {
      duration = _controller.value.duration;
      position = _controller.value.position;
      buffered = _controller.value.buffered;
      isBuffering = _controller.value.isBuffering;
      if (buffered.isNotEmpty) {
        _bufferedValue = buffered.first.end.inMilliseconds /
            _controller.value.duration.inMilliseconds;
      }
      debugPrint(
          '[Video Value]: ${_controller.value}\nposition=$position, duration=$duration, isBuffering=$isBuffering, buffered=${buffered} -> ${position.inMilliseconds / duration.inMilliseconds} $_bufferedValue');
      if (!_isDragging && duration > Duration.zero) {
        _progressValue = position.inMilliseconds
            .toDouble()
            .clamp(0, duration.inMilliseconds.toDouble());
      }
      if (position > duration) {
        _controller.seekTo(Duration.zero);
      }
      setState(() {});
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => Scaffold(
        appBar: orientation == Orientation.landscape
            ? null
            : AppBar(
                title: Text('Video'),
              ),
        body: Container(
          color: Colors.black,
          child: Center(
            child: _controller.value.isInitialized
                ? GestureDetector(
                    onTap: () {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                      setState(() {});
                    },
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        children: [
                          VideoPlayer(_controller),
                          if (!_controller.value.isPlaying)
                            Center(
                              child: Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                color: Colors.white,
                                child: Text('暂停'),
                              ),
                            ),
                          if (_controller.value.isBuffering)
                            Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.black.withOpacity(0.1),
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          Positioned(
                            bottom: 10,
                            left: 20,
                            right: 20,
                            child: Row(
                              children: [
                                Text(
                                  '${position.inMinutes.toString().padLeft(2, '0')} : ${(position.inSeconds % 60).toString().padLeft(2, '0')}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Expanded(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24.0),
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.transparent,
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
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
                                        child: Slider(
                                          value: _progressValue,
                                          min: 0,
                                          max: _controller
                                              .value.duration.inMilliseconds
                                              .toDouble(),
                                          onChangeStart: (value) {
                                            _isDragging = true;
                                            // _progressValue = value;
                                            setState(() {});
                                          },
                                          onChanged: (value) {
                                            debugPrint('Change Value: $value');
                                            _isDragging = true;
                                            _progressValue = value;
                                            setState(() {});
                                          },
                                          onChangeEnd: (value) async {
                                            _isDragging = false;
                                            _progressValue =
                                                value.toInt().toDouble();
                                            await _controller.seekTo(Duration(
                                                milliseconds: value.toInt()));
                                            _controller.play();
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${duration.inMinutes.toString().padLeft(2, '0')} : ${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.black.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
