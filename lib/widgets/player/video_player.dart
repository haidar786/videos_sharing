import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:videos_sharing/bloc/player/aspect_ratio_bloc.dart';
import 'package:videos_sharing/bloc/player/controller_bloc.dart';
import 'package:videos_sharing/model/aspect_ratio_model.dart';
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
  @override
  void initState() {
    Wakelock.enable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ControllerBloc, VideoPlayerController>(
      builder: (BuildContext context, VideoPlayerController controller) {
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
      },
    );
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }
}
