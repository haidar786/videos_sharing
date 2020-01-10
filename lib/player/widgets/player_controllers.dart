import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/player/bloc/aspect_ratio_bloc.dart';
import 'package:videos_sharing/player/bloc/state/aspect_ratio.dart';
import 'package:videos_sharing/player/bloc/controller_bloc.dart';
import 'package:videos_sharing/player/bloc/state/controller.dart';

class PlayerControllerWidget extends StatefulWidget {
  PlayerControllerWidget({@required this.isRotation});
  final bool isRotation;
  @override
  State<StatefulWidget> createState() {
    return _PlayerControllerWidgetState();
  }
}

class _PlayerControllerWidgetState extends State<PlayerControllerWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ControllerBloc, PlayerControllerState>(
      builder: (BuildContext context, PlayerControllerState controllerState) {
        _playPause(controllerState);
        controllerState.controller.addListener(() {
          if (controllerState.controller.value.duration ==
              controllerState.controller.value.position) {

          }
        });
//        _playPause(controllerState, widget.isRotation);
//        controllerState.controller.addListener(() {
//          if (controllerState.controller.value.duration ==
//              controllerState.controller.value.position) {
//            setState(() {
//              _isFinish = true;
//              controllerState.controller.pause();
//            });
//          }else{
//            _playPause(controllerState, widget.isRotation);
//          }
//        });
        return Row(
          children: <Widget>[
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
                    child: Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                      size: 27.0,
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
                    child: Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: 38.0,
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        AnimatedIcon(
                          icon: AnimatedIcons.pause_play,
                          size: 38.0,
                          color: Colors.white,
                          progress: _animationController,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    if (controllerState.controller.value.isPlaying) {
                      _animationController.forward();
                      controllerState.controller.pause();
                    } else {
                      _animationController.reverse();
                      controllerState.controller.play();
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
                    child: Icon(
                      Icons.skip_next,
                      color: Colors.white,
                      size: 38.0,
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<AspectRatioBloc, AspectRatioState>(
                builder:
                    (BuildContext context, AspectRatioState ratioModelState) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
                        child: Icon(
                          ratioModelState.icon,
                          color: Colors.white,
                          size: 27.0,
                        ),
                      ),
                      onTap: () {
//                                    BlocProvider.of<UiBloc>(context)
//                                        .hideShowAllTimer(addTime: true);
//                                    BlocProvider.of<UiBloc>(context)
//                                        .add(UiEvents.showTop);
                        switch (ratioModelState.aspectRatioEvents) {
                          case AspectRatioEvents.original:
                            BlocProvider.of<AspectRatioBloc>(context).add(
                                AspectRatioState(16 / 9, Icons.crop_5_4, "16:9",
                                    AspectRatioEvents.sixteenByNine, true));
                            break;
                          case AspectRatioEvents.sixteenByNine:
                            BlocProvider.of<AspectRatioBloc>(context).add(
                                AspectRatioState(4 / 3, Icons.crop_din, "4:3",
                                    AspectRatioEvents.fourByThree, true));
                            break;
                          case AspectRatioEvents.fourByThree:
                            BlocProvider.of<AspectRatioBloc>(context).add(
                                AspectRatioState(
                                    0.0,
                                    Icons.aspect_ratio,
                                    "Original",
                                    AspectRatioEvents.original,
                                    true));
                            break;
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  _playPause(PlayerControllerState controllerState) {
    if (controllerState.controller.value.isPlaying) {
      if (_animationController.status != AnimationStatus.reverse) {
        _animationController.reverse();
      }
    } else {
      if (_animationController.status != AnimationStatus.forward) {
        _animationController.forward();
      }
    }
  }
}
