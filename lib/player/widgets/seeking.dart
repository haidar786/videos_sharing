import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/player/bloc/controller_bloc.dart';
import 'package:videos_sharing/player/bloc/state/controller.dart';

class Seeking extends StatefulWidget {
  Seeking({@required this.isRotation});
  final bool isRotation;
  @override
  State<StatefulWidget> createState() {
    return _SeekingState();
  }
}

class _SeekingState extends State<Seeking> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ControllerBloc, PlayerControllerState>(
      builder: (BuildContext context, PlayerControllerState controllerState) {
        if (widget.isRotation) {
          controllerState.controller.addListener(() {
            if (mounted){
              setState(() {});
            }
          });
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: AutoSizeText(
                      _currentDuration(
                          controllerState.controller.value.position),
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: controllerState.controller.value.position.inSeconds
                          .toDouble(),
                      min: 0.0,
                      max: controllerState.controller.value.duration.inSeconds
                          .toDouble(),
                      onChanged: (double value) {
                        int seconds = value.toInt();
                        Duration duration = Duration(
                          hours: (seconds / 3600).floor(),
                          minutes: ((seconds % 3600) / 60).floor(),
                          seconds: (seconds % 60).floor(),
                        );
                        controllerState.controller.seekTo(duration);
                      },
                      onChangeStart: (value) {
//                                    BlocProvider.of<UiBloc>(context)
//                                        .add(UiEvents.showBottom);
//                                    BlocProvider.of<UiBloc>(context)
//                                        .hideShowAllTimer(
//                                        addTime: true,autoHide: false);
                      },
                      onChangeEnd: (value) {
//                                    BlocProvider.of<UiBloc>(context)
//                                        .hideShowAllTimer(
//                                        addTime: true,autoHide: controllerState.controller.value.isPlaying);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: AutoSizeText(
                      _durationLeft(controllerState.controller.value.duration,
                          controllerState.controller.value.position),
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  String _currentDuration(Duration duration) {
    if (duration.inHours == 0) {
      return "${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60).toString().padLeft(2, '0'))}";
    } else {
      return duration.toString().split('.').first;
    }
  }

  String _durationLeft(Duration totalDuration, Duration position) {
    var duration = totalDuration - position;
    if (duration.inHours == 0) {
      return "-${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60).toString().padLeft(2, '0'))}";
    } else {
      return "-" + duration.toString().split('.').first;
    }
  }
}
