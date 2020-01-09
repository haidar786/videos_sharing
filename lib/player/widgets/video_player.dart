import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:videos_sharing/player/bloc/aspect_ratio_bloc.dart';
import 'package:videos_sharing/player/bloc/controller_bloc.dart';
import 'package:videos_sharing/player/bloc/state/aspect_ratio.dart';
import 'package:videos_sharing/player/bloc/state/controller.dart';
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
   // SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ControllerBloc, PlayerControllerState>(
      builder: (BuildContext context, PlayerControllerState state) {
        if (state.controller.value.initialized) {
          return BlocBuilder<AspectRatioBloc, AspectRatioState>(
            builder: (context, ratioModel) {
              return AspectRatio(
                aspectRatio: ratioModel.aspectRatio == 0.0
                    ? state.controller.value.aspectRatio
                    : ratioModel.aspectRatio,
                child: VideoPlayer(state.controller),
              );
            },
          );
        } else {
          state.controller.addListener(() {
            if (state.controller.value.hasError) {
              print(state.controller.value.errorDescription);
              widget.globalKey.currentState.showSnackBar(
                SnackBar(
                  content: Text(
                      "This file has error or not supported by this video player."),
                ),
              );
            }
          });
          state.controller.initialize().then((_) {
            state.controller.play();
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
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }
}
