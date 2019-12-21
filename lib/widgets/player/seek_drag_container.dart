import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:videos_sharing/bloc/player/controller_bloc.dart';
import 'package:videos_sharing/bloc/player/volume_bloc.dart';
import 'package:videos_sharing/bloc/state/volume.dart';
import 'package:volume_watcher/volume_watcher.dart';

class SeekDragContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SeekDragContainerState();
  }
}

class _SeekDragContainerState extends State<SeekDragContainer> {
  bool isVolume;
//  double currentVolume = 8.0;
//  double maxVolume = 15.0;

  @override
  void initState() {
    //  _initPlatformState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var center = MediaQuery.of(context).size.width / 2;
    return BlocBuilder<ControllerBloc, VideoPlayerController>(
      builder: (BuildContext context, VideoPlayerController controller) {
        return BlocBuilder<VolumeBloc, VolumeControllerState>(
          builder: (BuildContext context, VolumeControllerState state) {
            return GestureDetector(
              onTap: () {},
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
                  print(state.currentVolume / state.maxVolume);
                  VolumeWatcher.setVolume(state.currentVolume);
                  BlocProvider.of<VolumeBloc>(context).add(
                    VolumeControllerState(state.currentVolume, state.maxVolume),
                  );
                  setState(() {});
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
      },
    );
  }

//  Future<void> _initPlatformState() async {
//    num initVolume = await VolumeWatcher.getCurrentVolume;
//    num maxVolume = await VolumeWatcher.getMaxVolume;
//
//    if (!mounted) return;
//
//    setState(() {
//      this.maxVolume = maxVolume.toDouble();
//      currentVolume = initVolume.toDouble();
//    });
//  }
}
