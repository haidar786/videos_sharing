import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/player/bloc/brightness_bloc.dart';
import 'package:videos_sharing/player/bloc/controller_bloc.dart';
import 'package:videos_sharing/player/bloc/state/brightness.dart';
import 'package:videos_sharing/player/bloc/state/controller.dart';
import 'package:videos_sharing/player/bloc/state/volume.dart';
import 'package:videos_sharing/player/bloc/volume_bloc.dart';
import 'package:videos_sharing/player/bloc/UiBloc.dart';

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
    var center = MediaQuery.of(context).size.width / 2;
    return BlocBuilder<ControllerBloc, PlayerControllerState>(
      builder: (BuildContext context, PlayerControllerState playerState) {
        return BlocBuilder<VolumeBloc, VolumeControllerState>(
          builder: (BuildContext _, VolumeControllerState volumeState) {
            return GestureDetector(
              onHorizontalDragUpdate: (update) {
                double a = playerState.controller.value.position.inMicroseconds
                    .toDouble();
                a += (update.primaryDelta *
                        ((playerState.controller.value.duration.inSeconds /
                                550) *
                            500000))
                    .clamp(-8000000, 8000000);
                a = a.clamp(
                    0.0,
                    playerState.controller.value.duration.inMicroseconds
                        .toDouble());
                Duration duration = Duration(microseconds: a.toInt());
                playerState.controller.seekTo(duration);
              },
              onHorizontalDragEnd: (details) {},
              onVerticalDragUpdate: (update) {
                if (isVolume) {
                  volumeState.currentVolume -=
                      (update.primaryDelta * volumeState.maxVolume / 300);
                  volumeState.currentVolume = volumeState.currentVolume
                      .clamp(0.0, volumeState.maxVolume);
                  //print(state.currentVolume / state.maxVolume);
                  BlocProvider.of<VolumeBloc>(context).add(
                    VolumeControllerState(
                        volumeState.currentVolume, volumeState.maxVolume, true),
                  );
                } else {
                  brightness -= (update.primaryDelta * 0.0035);
                  brightness = brightness.clamp(0.0, 1.0);
                  BlocProvider.of<BrightnessBloc>(context)
                      .add(BrightnessControllerState(brightness, true));
                }
              },
              onVerticalDragStart: (details) {
                if (details.globalPosition.dx > center) {
                  isVolume = true;
                } else {
                  isVolume = false;
                  brightness = BlocProvider.of<BrightnessBloc>(context)
                      .state
                      .currentBrightness;
                }
              },
              onVerticalDragEnd: (details) {
                if (isVolume) {
                  BlocProvider.of<VolumeBloc>(context).add(
                      VolumeControllerState(volumeState.currentVolume,
                          volumeState.maxVolume, false));
                } else {
                  BlocProvider.of<BrightnessBloc>(context)
                      .add(BrightnessControllerState(brightness, false));
                }
              },
              onDoubleTap: () {
                print("double tap");
              },
              onTap: () {
                BlocProvider.of<UiBloc>(context).add(UiEvents.showAll);
              },
            );
          },
        );
      },
    );
  }
}
