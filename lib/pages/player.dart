import 'dart:async';

import 'package:flutter/material.dart';
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
  bool _showOverlay = false;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  _hideOverlay() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      _timer = Timer(Duration(seconds: 2), onDoneLoading);
    } else {
      _timer = Timer(Duration(seconds: 2), onDoneLoading);
    }
  }

  onDoneLoading() async {
    setState(() {
      _showOverlay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.initialized
            ? GestureDetector(
                child: Stack(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    _showOverlay
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: Container(
                              color: Colors.black45,
                            ),
                          )
                        : Container(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _showOverlay ? _controllers(context) : Container(),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _showOverlay = true;
                  });
                  _hideOverlay();
                },
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  Widget _controllers(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          _controller.value.duration.inHours.toString() +
              _controller.value.duration.inMinutes.toString() +
              _controller.value.duration.inSeconds.toString(),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
