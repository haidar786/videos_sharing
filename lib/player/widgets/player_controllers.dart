import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/player/bloc/UiBloc.dart';
import 'package:videos_sharing/player/bloc/controller_bloc.dart';
import 'package:videos_sharing/player/bloc/state/controller.dart';
import 'package:videos_sharing/player/bloc/state/ui.dart';

class PlayerControllerWidget extends StatefulWidget {
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
    var mediaQuery = MediaQuery.of(context);
    return Container(
      width: mediaQuery.orientation == Orientation.portrait
          ? mediaQuery.size.width
          : mediaQuery.size.height,
      child: BlocBuilder<ControllerBloc, PlayerControllerState>(
        builder: (BuildContext context, PlayerControllerState controllerState) {
          return BlocBuilder<UiBloc, UiState>(
            builder: (BuildContext context, UiState uiState) {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: uiState.showCenter
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(
                            Icons.skip_previous,
                            size: 36.0,
                            color: Colors.grey[600],
                          ),
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AnimatedIcon(
                                icon: AnimatedIcons.pause_play,
                                size: 56.0,
                                color: Colors.white,
                                progress: _animationController,
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
                          Icon(
                            Icons.skip_next,
                            size: 36.0,
                            color: Colors.grey[600],
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
