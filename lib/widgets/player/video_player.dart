import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:videos_sharing/bloc/player/aspect_ratio_bloc.dart';
import 'package:videos_sharing/bloc/player/controller_bloc.dart';
import 'package:videos_sharing/model/aspect_ratio_model.dart';
import 'package:wakelock/wakelock.dart';

class VideoPlayerWidget extends StatefulWidget {
  VideoPlayerWidget(
      {Key key, @required this.videoPath, @required this.globalKey})
      : super(key: key);
  final videoPath;
  final GlobalKey<ScaffoldState> globalKey;
  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerWidgetState();
  }
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  @override
  void initState() {
    Wakelock.enable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ControllerBloc, VideoPlayerController>(
      builder: (BuildContext context, VideoPlayerController controller) {
        if (controller.value.initialized) {
          return BlocBuilder<AspectRatioBloc, AspectRatioModel>(
            builder: (context, ratioModel) {
              return AspectRatio(
                aspectRatio: ratioModel.aspectRatio == 0.0
                    ? controller.value.aspectRatio
                    : ratioModel.aspectRatio,
                child: VideoPlayer(controller),
              );
            },
          );
        } else {
          controller.addListener(() {
            if (controller.value.hasError) {
              print(controller.value.errorDescription);
              widget.globalKey.currentState.showSnackBar(
                SnackBar(
                  content: Text(
                      "This file has error or not supported by this video player."),
                ),
              );
            }
          });
          controller.initialize().then((_) {
            controller.play();
            setState(() {});
          });
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }
}
