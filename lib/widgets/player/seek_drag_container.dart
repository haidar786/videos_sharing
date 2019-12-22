import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:videos_sharing/bloc/player/brightness_bloc.dart';
import 'package:videos_sharing/bloc/player/controller_bloc.dart';
import 'package:videos_sharing/bloc/player/volume_bloc.dart';
import 'package:videos_sharing/bloc/state/volume.dart';

class SeekDragContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SeekDragContainerState();
  }
}

class _SeekDragContainerState extends State<SeekDragContainer> {
  bool isVolume;
  double brightness = 0.5;

  @override
  Widget build(BuildContext context) {
    var center = MediaQuery
        .of(context)
        .size
        .width / 2;
    return BlocBuilder<ControllerBloc, VideoPlayerController>(
      builder: (BuildContext context, VideoPlayerController controller) {
        return BlocBuilder<VolumeBloc, VolumeControllerState>(
          builder: (BuildContext _, VolumeControllerState state) {
            return GestureDetector(
              onHorizontalDragUpdate: (update) {
                double a = controller.value.position.inSeconds.toDouble();
                a += update.primaryDelta * 0.5;
                a = a.clamp(
                    0.0, controller.value.duration.inSeconds.toDouble());
                int seconds = a.toInt();
                Duration duration = Duration(
                  hours: (seconds / 3600).floor(),
                  minutes: ((seconds % 3600) / 60).floor(),
                  seconds: (seconds % 60).floor(),
                );
                controller.seekTo(duration);
              },
              onVerticalDragUpdate: (update) {
                if (isVolume) {
                  state.currentVolume -=
                  (update.primaryDelta * state.maxVolume / 300);
                  state.currentVolume =
                      state.currentVolume.clamp(0.0, state.maxVolume);
                  //print(state.currentVolume / state.maxVolume);
                  BlocProvider.of<VolumeBloc>(context).add(
                    VolumeControllerState(state.currentVolume, state.maxVolume),
                  );
                } else {
                  print("brightness $update.globalPosition.dx");
                  brightness -= (update.primaryDelta * 0.0035);
                  print("before " + brightness.toString());
                  brightness = brightness.clamp(0.0, 1.0);
                  print("after " + brightness.toString());
                  BlocProvider.of<BrightnessBloc>(context).add(brightness);
                }
              },
              onVerticalDragStart: (details) {
                if (details.globalPosition.dx > center) {
                  isVolume = true;
                } else {
                  isVolume = false;
                  brightness = BlocProvider.of<BrightnessBloc>(context).state;
                }
              },
              onDoubleTap: () {
                print("double tap");
              },
              onTap: () {
                print("tap");
              },
            );
          },
        );
      },
    );
  }
}