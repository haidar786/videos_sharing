import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:videos_sharing/bloc/player/controller_bloc.dart';

class BottomPlayerWidgets extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomPlayerWidgets();
  }
}

class _BottomPlayerWidgets extends State<BottomPlayerWidgets> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ControllerBloc, VideoPlayerController>(
      builder: (BuildContext context, VideoPlayerController controller) {
        if (controller.value.initialized) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: AutoSizeText(
                      format(controller.value.position),
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: controller.value.position.inSeconds.toDouble(),
                      min: 0.0,
                      max: controller.value.duration.inSeconds.toDouble(),
                      onChanged: (double value) {
                        int seconds = value.toInt();
                        Duration duration = Duration(
                          hours: (seconds / 3600).floor(),
                          minutes: ((seconds % 3600) / 60).floor(),
                          seconds: (seconds % 60).floor(),
                        );
                        controller.seekTo(duration);
                      },
                      onChangeStart: (value) {
//                    if (_timer != null && _timer.isActive) {
//                      _timer.cancel();
//                    }
                      },
                      onChangeEnd: (value) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: AutoSizeText(
                      format(controller.value.duration),
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          controller.addListener(() {
              setState(() {});
          });
          return Container();
        }
      },
    );
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
}
