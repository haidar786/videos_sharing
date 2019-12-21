import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:videos_sharing/bloc/player/controller_bloc.dart';

// ignore: must_be_immutable
class SeekDragContainer extends StatelessWidget {
  bool isVolume;
  @override
  Widget build(BuildContext context) {
    var center = MediaQuery.of(context).size.width / 2;
    return BlocBuilder<ControllerBloc, VideoPlayerController>(
      builder: (BuildContext context, VideoPlayerController controller) {
        return GestureDetector(
          onTap: () {},
          onHorizontalDragUpdate: (update) {
            double a = controller.value.position.inSeconds.toDouble();
            a += update.primaryDelta * 0.5;
            a = a.clamp(0.0, controller.value.duration.inSeconds.toDouble());
            int seconds = a.toInt();
            Duration duration = Duration(
              hours: (seconds / 3600).floor(),
              minutes: ((seconds % 3600) / 60).floor(),
              seconds: (seconds % 60).floor(),
            );
            //print(duration);
            controller.seekTo(duration);
          },
          onHorizontalDragStart: (details) {
//              if (!_isLocked) {
//                setState(() {
//                  _showBottom = true;
//                });
//                if (_bottomTimer != null && _bottomTimer.isActive) {
//                  _bottomTimer.cancel();
//                }
//              } else {
//                _hideShowLockIcon();
//              }
          },
          onHorizontalDragEnd: (details) {
//              if (!_isLocked) {
//                if (_bottomTimer != null && _bottomTimer.isActive) {
//                  _bottomTimer.cancel();
//                  _bottomTimer = Timer(Duration(seconds: 1), onSeekingDone);
//                } else {
//                  _bottomTimer = Timer(Duration(seconds: 1), onSeekingDone);
//                }
//              }
          },
          onVerticalDragUpdate: (update) {
            if (isVolume) {
              print("volume $update.globalPosition.dx");
            } else {
              print("brightness $update.globalPosition.dx");
            }
          },
          onVerticalDragStart: (details) {
            if (details.globalPosition.dx > center) {
              isVolume = true;
            } else {
              isVolume = false;
            }
          },
        );
      },
    );
  }
}
