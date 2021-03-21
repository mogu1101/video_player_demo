import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_demo/video_player.dart';

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
  MyHomePage({Key key, this.title = ''}) : super(key: key);
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
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/guang.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                '码率1Mbps',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/guang_1m.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                '码率512kbps',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/guang_512k.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                '码率512kbps',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/guang_512k.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                '码率512kbps',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/guang_512k.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                '怎样飞得更高 3Mbps 1364x720 316MB',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/test/fly_high_3m_1364_720.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                '怎样飞得更高 2Mbps 1364x720 215MB',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/test/fly_high_2m_1364_720.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                '怎样飞得更高 1Mbps 1364x720 114MB',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/test/fly_high_1024kbps_1364_720.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                '怎样飞得更高 1Mbps 4096x2160 113MB',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/test/fly_high_1m_4096_2160.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                '怎样飞得更高 678kbps 1364x720 80MB',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/test/fly_high_678kbps_1364_720.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                '怎样飞得更高 400kbps 1024x540 53MB',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/test/fly_high_400kbps_1024_540.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                '简单电路 2Mbps 1364x720 338MB',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/test/%E7%AE%80%E5%8D%95%E7%94%B5%E8%B7%AF3.14-%E7%A0%81%E7%8E%872.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                '简单电路 1Mbps 1364x720 182MB',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/test/%E7%AE%80%E5%8D%95%E7%94%B5%E8%B7%AF3.13%EF%BC%88%E4%BD%8E%E7%89%88%E6%9C%AC%EF%BC%89.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                '简单电路（自己压缩） 1Mbps 1364x720 186MB',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/test/simple_electric_1Mbps_1364_720.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                '简单电路 h265 1Mbps 1364x720 188MB',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/test/simple_electric_h265_1M_1364_720.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                '简单电路 h265 512kbps 1364x720 102MB',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/test/simple_electric_h265_512k_1364_720.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                '简单电路 h265 300kbps 1364x720 72MB',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.fbcontent.cn/pumpkin/test/simple_electric_h265_300k_1364_720.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                'AI课 1',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.oss-cn-beijing.aliyuncs.com/pumpkin/test/v.f100020.mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                'AI课 2',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.oss-cn-beijing.aliyuncs.com/pumpkin/test/v.f100020%20(1).mp4')));
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                'AI课 3',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => VideoPage(
                        'https://solar-test.oss-cn-beijing.aliyuncs.com/pumpkin/test/v.f100030.mp4')));
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
  SciVideoPlayerController _controller;
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
    _controller = SciVideoPlayerController.network(url);
    //   ..initialize().then((value) {
    //     _controller.play();
    //     setState(() {});
    //   });
    // _controller.addListener(() {
    //   duration = _controller.value.duration;
    //   position = _controller.value.position;
    //   buffered = _controller.value.buffered;
    //   isBuffering = buffered.isEmpty ||
    //       (buffered.last.end < position + Duration(seconds: 1) &&
    //           buffered.last.end < duration);
    //   if (buffered.isNotEmpty) {
    //     _bufferedValue = buffered.first.end.inMilliseconds /
    //         _controller.value.duration.inMilliseconds;
    //   }
    //   // debugPrint(
    //   // '[Video Value]: ${_controller.value}\nposition=$position, duration=$duration, isBuffering=$isBuffering, buffered=${buffered} -> ${position.inMilliseconds / duration.inMilliseconds} $_bufferedValue');
    //   debugPrint(
    //       '----------isDragging: $_isDragging, $isBuffering, $_progressValue, $buffered');
    //   if (!_isDragging && duration > Duration.zero) {
    //     _progressValue = position.inMilliseconds
    //         .toDouble()
    //         .clamp(0, duration.inMilliseconds.toDouble());
    //   }
    //   if (position > duration) {
    //     _controller.seekTo(Duration.zero);
    //   }
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
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
        body: SciVideoPlayer(_controller),
        // Container(
        //   color: Colors.black,
        //   child: Center(
        //     child: _controller.value.isInitialized
        //         ? GestureDetector(
        //             onTap: () {
        //               if (_controller.value.isPlaying) {
        //                 _controller.pause();
        //               } else {
        //                 _controller.play();
        //               }
        //               setState(() {});
        //             },
        //             child: AspectRatio(
        //               aspectRatio: _controller.value.aspectRatio,
        //               child: Stack(
        //                 children: [
        //                   VideoPlayer(_controller),
        //                   if (!_controller.value.isPlaying)
        //                     Center(
        //                       child: Container(
        //                         width: 40,
        //                         height: 40,
        //                         alignment: Alignment.center,
        //                         color: Colors.white,
        //                         child: Text('暂停'),
        //                       ),
        //                     ),
        //                   if (isBuffering)
        //                     Center(
        //                       child: CircularProgressIndicator(
        //                         backgroundColor: Colors.black.withOpacity(0.1),
        //                         valueColor:
        //                             AlwaysStoppedAnimation<Color>(Colors.white),
        //                       ),
        //                     ),
        //                   Positioned(
        //                     bottom: 10,
        //                     left: 20,
        //                     right: 20,
        //                     child: Row(
        //                       children: [
        //                         Text(
        //                           '${position.inMinutes.toString().padLeft(2, '0')} : ${(position.inSeconds % 60).toString().padLeft(2, '0')}',
        //                           style: TextStyle(color: Colors.white),
        //                         ),
        //                         Expanded(
        //                           child: Stack(
        //                             alignment: Alignment.center,
        //                             children: [
        //                               Padding(
        //                                 padding: const EdgeInsets.symmetric(
        //                                     horizontal: 24.0),
        //                                 child: LinearProgressIndicator(
        //                                   backgroundColor: Colors.transparent,
        //                                   valueColor: AlwaysStoppedAnimation<
        //                                           Color>(
        //                                       Colors.black.withOpacity(0.5)),
        //                                   value: _bufferedValue,
        //                                   minHeight: 4,
        //                                 ),
        //                               ),
        //                               SliderTheme(
        //                                 data: SliderTheme.of(context).copyWith(
        //                                   activeTrackColor: Colors.white,
        //                                   inactiveTrackColor:
        //                                       Colors.white.withOpacity(0.2),
        //                                   thumbShape: RoundSliderThumbShape(
        //                                     enabledThumbRadius: 6,
        //                                     disabledThumbRadius: 8,
        //                                   ),
        //                                   thumbColor: Colors.white,
        //                                   trackHeight: 4,
        //                                 ),
        //                                 child: Slider(
        //                                   value: _progressValue,
        //                                   min: 0,
        //                                   max: _controller
        //                                       .value.duration.inMilliseconds
        //                                       .toDouble(),
        //                                   onChangeStart: (value) {
        //                                     _isDragging = true;
        //                                     // _progressValue = value;
        //                                     setState(() {});
        //                                   },
        //                                   onChanged: (value) {
        //                                     debugPrint('Change Value: $value');
        //                                     _isDragging = true;
        //                                     _progressValue = value;
        //                                     setState(() {});
        //                                   },
        //                                   onChangeEnd: (value) async {
        //                                     _progressValue =
        //                                         value.toInt().toDouble();
        //                                     await _controller.seekTo(Duration(
        //                                         milliseconds: value.toInt()));
        //                                     await _controller.play();
        //                                     _isDragging = false;
        //                                     setState(() {});
        //                                   },
        //                                 ),
        //                               ),
        //                             ],
        //                           ),
        //                         ),
        //                         Text(
        //                           '${duration.inMinutes.toString().padLeft(2, '0')} : ${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
        //                           style: TextStyle(color: Colors.white),
        //                         ),
        //                       ],
        //                     ),
        //                   )
        //                 ],
        //               ),
        //             ),
        //           )
        //         : Center(
        //             child: CircularProgressIndicator(
        //               backgroundColor: Colors.black.withOpacity(0.1),
        //               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        //             ),
        //           ),
        //   ),
        // ),
      ),
    );
  }
}
