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
      _timer = Timer(Duration(seconds: 2), onDoneLoading);
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
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: _controller.value.initialized
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
                      alignment: Alignment.bottomCenter,
                      child: _showOverlay ? _controllers(context) : Container(),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
      onTap: _hideShowOverlay,
    );
  }

  Widget _controllers(BuildContext context) {
    return Row(
      children: <Widget>[Text(format(_controller.value.duration))],
    );
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
