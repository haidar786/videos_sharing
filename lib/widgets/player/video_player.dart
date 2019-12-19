import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        ? BlocBuilder<AspectRatioBloc, double>(
            builder: (context, ratio) {
              return AspectRatio(
                aspectRatio: ratio,
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
    _controller.dispose();
    Wakelock.disable();
    super.dispose();
  }
}
