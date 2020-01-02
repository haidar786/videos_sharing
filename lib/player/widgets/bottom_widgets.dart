import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/player/bloc/UiBloc.dart';
import 'package:videos_sharing/player/bloc/controller_bloc.dart';
import 'package:videos_sharing/player/bloc/state/controller.dart';
import 'package:videos_sharing/player/bloc/state/ui.dart';

class BottomPlayerWidgets extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomPlayerWidgets();
  }
}

class _BottomPlayerWidgets extends State<BottomPlayerWidgets> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ControllerBloc, PlayerControllerState>(
      builder: (BuildContext context, PlayerControllerState controllerState) {
        if (controllerState.controller.value.initialized) {
          return BlocBuilder<UiBloc,UiState>(
             builder: (BuildContext context, UiState uiState) {
               return  AnimatedOpacity(
                 opacity: uiState.showBottom ? 1.0 :0.0,
                 duration: Duration(milliseconds: 500),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: <Widget>[
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: <Widget>[
                         Padding(
                           padding: const EdgeInsets.only(left: 12.0),
                           child: AutoSizeText(
                             _currentDuration(controllerState.controller.value.position),
                             style: TextStyle(color: Colors.white, fontSize: 12.0),
                           ),
                         ),
                         Expanded(
                           child: Slider(
                             value: controllerState.controller.value.position.inSeconds.toDouble(),
                             min: 0.0,
                             max: controllerState.controller.value.duration.inSeconds.toDouble(),
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
                             },
                             onChangeEnd: (value) {
                             },
                           ),
                         ),
                         Padding(
                           padding: const EdgeInsets.only(right: 12.0),
                           child: AutoSizeText(
                             _durationLeft(
                                 controllerState.controller.value.duration, controllerState.controller.value.position),
                             style: TextStyle(color: Colors.white, fontSize: 12.0),
                           ),
                         ),
                       ],
                     ),
                   ],
                 ),
               );
             },
          );
        } else {
          controllerState.controller.addListener(() {
            setState(() {});
          });
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
