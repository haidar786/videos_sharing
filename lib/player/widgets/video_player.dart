import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srt_parser/srt_parser.dart';
import 'package:subtitle_wrapper_package/models/style/subtitle_style.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';
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
  final String videoPath;
  final GlobalKey<ScaffoldState> globalKey;
  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerWidgetState();
  }
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {

  @override
  void initState() {
    _getSubUrl();
    Wakelock.enable();
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
                child: SubTitleWrapper(
                  videoChild: VideoPlayer(state.controller),
                  subtitleController: SubtitleController(
                    subtitlesContent: _srtSub(),
                    showSubtitles: true,
                  ),
                  subtitleStyle:
                      SubtitleStyle(textColor: Colors.white, hasBorder: true,fontSize: 20.0),
                  videoPlayerController: state.controller,
                ),
              );
            },
          );
        } else {
          state.controller.addListener(() {
            if (state.controller.value.hasError) {
              print(state.controller.value.errorDescription);
              widget.globalKey.currentState.removeCurrentSnackBar();
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

  String _getSubUrl() {
    int dotIndex = widget.videoPath.lastIndexOf('.');
    String subUrl = widget.videoPath.substring(1, dotIndex) + ".srt";
    return subUrl;
  }

  String _srtSub() {
    String vvtSub = "";
    try {
      List<Subtitle> subtitles = parseSrt(File(_getSubUrl()).readAsStringSync());
      for (Subtitle item in subtitles) {
        Duration startTime = Duration(milliseconds: item.range.begin);
        Duration endTime = Duration(milliseconds: item.range.end);
        vvtSub = vvtSub +
            startTime.toString().substring(0, 11).padLeft(12, '0') +
            " --> " +
            endTime.toString().substring(0, 11).padLeft(12, '0') +
            "\n";

        item.parsedLines.forEach((Line line) {
          return line.subLines.forEach((SubLine subLine) {
            vvtSub = vvtSub + subLine.rawString;
          });
        });

        vvtSub = vvtSub + "\n\n";
      }
    }catch (error){
      print(error);
//      widget.globalKey.currentState.removeCurrentSnackBar();
//      widget.globalKey.currentState.showSnackBar(
//        SnackBar(
//          content: Text(error.toString()),
//        ),
//      );
    }
    return vvtSub;
  }

  @override
  void dispose() {
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }
}