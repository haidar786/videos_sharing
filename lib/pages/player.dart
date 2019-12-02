import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class VideoPlayerPage extends StatefulWidget {
  VideoPlayerPage(
      {Key key,
      @required this.videoUrl,
      @required this.videoName,
      @required this.mediaQuery})
      : super(key: key);
  final String videoUrl;
  final MediaQueryData mediaQuery;
  final String videoName;
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage>
    with SingleTickerProviderStateMixin {
  VideoPlayerController _controller;
  AnimationController _animationController;
  bool _showOverlay = false;
  Timer _timer;

  double _continuousValue = 0.0;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        setState(() {
          _continuousValue = _controller.value.position.inSeconds.toDouble();
        });
      })
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  _hideShowOverlay() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      SystemChrome.setEnabledSystemUIOverlays([]);
      setState(() {
        _showOverlay = false;
      });
    } else if (_showOverlay) {
      SystemChrome.setEnabledSystemUIOverlays([]);
      setState(() {
        _showOverlay = false;
      });
    } else {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      setState(() {
        _showOverlay = true;
      });
      _timer = Timer(Duration(seconds: 2), onDoneLoading);
    }
  }

  onDoneLoading() {
    if (mounted && _controller.value.isPlaying) {
      setState(() {
        _showOverlay = false;
      });
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _controller.value.initialized
            ? Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  _showOverlay
                      ? AspectRatio(
                          aspectRatio: mediaQuery.size.aspectRatio,
                          child: Container(
                            color: Colors.black45,
                          ),
                        )
                      : Container(),
                  Align(
                    alignment: Alignment.topCenter,
                    child: _showOverlay
                        ? Container(
                            height: kToolbarHeight + 24.0,
                            child: AppBar(
                              backgroundColor: Colors.transparent,
                              title: AutoSizeText(
                                widget.videoName,
                                maxLines: 1,
                              ),
                              actions: <Widget>[
                                InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.more_vert),
                                  ),
                                  onTap: () {},
                                )
                              ],
                            ),
                          )
                        : Container(),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: _showOverlay
                        ? _showCenterController(mediaQuery, theme)
                        : Container(),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _showOverlay
                        ? _showBottomControllers(context, mediaQuery)
                        : Container(),
                  ),
                ],
              )
            : Stack(
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    title: AutoSizeText(
                      widget.videoName,
                      maxLines: 1,
                    ),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator())
                ],
              ),
      ),
      onTap: _hideShowOverlay,
    );
  }

  Widget _showBottomControllers(
      BuildContext context, MediaQueryData mediaQuery) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: AutoSizeText(
                _continuousValue.toString(),
                style: TextStyle(color: Colors.white, fontSize: 12.0),
              ),
            ),
            Expanded(
              child: Slider(
                value: _continuousValue,
                label: _continuousValue.toString(),
                min: 0.0,
                max: _controller.value.duration.inSeconds.toDouble(),
                onChanged: (double value) {
                  int seconds = value.toInt();
                  Duration duration = Duration(
                    hours: (seconds / 3600).floor(),
                    minutes: ((seconds % 3600) / 60).floor(),
                    seconds: (seconds % 60).floor(),
                  );
                  _controller.seekTo(duration);
                  print(duration);

                  },
                onChangeStart: (value) {
                  _controller.pause();
                },
                onChangeEnd: (value) {
                  _controller.play();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AutoSizeText(
                format(_controller.value.duration),
                style: TextStyle(color: Colors.white, fontSize: 12.0),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _showCenterController(MediaQueryData mediaQuery, ThemeData theme) {
    return Container(
      width: mediaQuery.orientation == Orientation.portrait
          ? mediaQuery.size.width
          : mediaQuery.size.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            Icons.skip_previous,
            size: 40.0,
            color: Colors.grey[600],
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedIcon(
                icon: AnimatedIcons.pause_play,
                progress: _animationController,
                size: 56.0,
                color: Colors.white,
              ),
            ),
            onTap: () {
              _controller.value.isPlaying
                  ? _animationController.forward()
                  : _animationController.reverse();
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
                if (_timer != null && _timer.isActive) {
                  _timer.cancel();
                  _timer = Timer(Duration(seconds: 1), onDoneLoading);
                } else {
                  _timer = Timer(Duration(seconds: 1), onDoneLoading);
                }
              }
              setState(() {});
            },
          ),
          Icon(
            Icons.skip_next,
            size: 40.0,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _controller.dispose();
    _animationController.dispose();
  }
}
