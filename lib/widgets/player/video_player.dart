import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:videos_sharing/bloc/ratio/aspect_ratio_bloc.dart';
import 'package:wakelock/wakelock.dart';

class VideoPlayerWidget extends StatefulWidget {
  VideoPlayerWidget({Key key, @required this.videoPath}) : super(key: key);
  final videoPath;
  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerWidgetState();
  }
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController _controller;
  @override
  void initState() {
    Wakelock.enable();
    _controller = VideoPlayerController.network(widget.videoPath);
    _controller.addListener(() {});
    _controller.initialize().then((_) {
      _controller.play();
      _controller.setLooping(true);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.initialized
        ? StreamBuilder(
            stream: aspectRatioBloc.aspectRationStream,
            initialData: _controller.value.aspectRatio,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return AspectRatio(
                aspectRatio: snapshot.data,
                child: VideoPlayer(_controller),
              );
            },
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  @override
  void dispose() {
    aspectRatioBloc.dispose();
    _controller.dispose();
    Wakelock.disable();
    super.dispose();
  }
}
