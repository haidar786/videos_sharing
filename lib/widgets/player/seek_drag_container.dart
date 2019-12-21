import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:videos_sharing/bloc/player/controller_bloc.dart';

class SeekDragContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            print(duration);
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
          onVerticalDragUpdate: (update) {},
        );
      },
    );
  }
}
