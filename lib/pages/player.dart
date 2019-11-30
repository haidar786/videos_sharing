import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  VideoPlayerPage({Key key, @required this.videoUrl, @required this.mediaQuery})
      : super(key: key);
  final String videoUrl;
  final MediaQueryData mediaQuery;
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController _controller;
  bool _showOverlay = true;
  Timer _timer;

  double _continuousValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  _hideShowOverlay() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      setState(() {
        _showOverlay = false;
      });
    } else {
      setState(() {
        _showOverlay = true;
      });
      _timer = Timer(Duration(seconds: 3), onDoneLoading);
    }
  }

  onDoneLoading() {
    if (mounted) {
      setState(() {
        _showOverlay = false;
      });
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
                      alignment: Alignment.center,
                      child: _showOverlay
                          ? _showCenterController(mediaQuery, theme)
                          : Container()),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _showOverlay
                        ? _showBottomControllers(context, mediaQuery)
                        : Container(),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      onTap: _hideShowOverlay,
    );
  }

  Widget _showBottomControllers(
      BuildContext context, MediaQueryData mediaQuery) {
    return Container(
      color: Colors.red,
      height: mediaQuery.orientation == Orientation.portrait
          ? mediaQuery.size.height / 20
          : mediaQuery.size.width / 20,
      child: Row(
        children: <Widget>[
          Text(
            format(_controller.value.duration),
            style: TextStyle(color: Colors.white),
          ),
          Expanded(
            child: Slider(
              value: _continuousValue,
              min: 0.0,
              max: 50.0,
              onChanged: (double value) {
                setState(() {
                  _continuousValue = value;
                });
              },
            ),
          ),
          Text(
            format(_controller.value.duration),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
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
            size: 32.0,
            color: Colors.grey[600],
          ),
          GestureDetector(
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              size: 56.0,
              color: Colors.white,
            ),
            onTap: () {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
              setState(() {});
            },
          ),
          Icon(
            Icons.skip_next,
            size: 32.0,
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
    _controller.dispose();
  }
}
