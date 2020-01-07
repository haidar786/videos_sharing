import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/player/bloc/aspect_ratio_bloc.dart';
import 'package:videos_sharing/player/bloc/state/aspect_ratio.dart';
import 'package:videos_sharing/player/bloc/ui_bloc.dart';
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
    return BlocBuilder<ControllerBloc, PlayerControllerState>(
      builder: (BuildContext context, PlayerControllerState controllerState) {
        return BlocBuilder<UiBloc, UiState>(
          builder: (BuildContext context, UiState uiState) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: uiState.showCenter
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.lock_outline),
                          ),
                          onTap: () {},
                        ),
                        Icon(
                          Icons.skip_previous,
                          size: 40.0,
                          color: Colors.grey[600],
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnimatedIcon(
                              icon: AnimatedIcons.pause_play,
                              size: 40.0,
                              color: Colors.white,
                              progress: _animationController,
                            ),
                          ),
                          onTap: () {
                            if (controllerState.controller.value.isPlaying) {
                              _animationController.forward();
                              controllerState.controller.pause();
                              BlocProvider.of<UiBloc>(context).hideShowAllTimer(
                                  addTime: true,
                                  autoHide: controllerState
                                      .controller.value.isPlaying);
                            } else {
                              _animationController.reverse();
                              controllerState.controller.play();
                              BlocProvider.of<UiBloc>(context).hideShowAllTimer(
                                  addTime: false,
                                  autoHide: controllerState
                                      .controller.value.isPlaying);
                            }
                          },
                        ),
                        Icon(
                          Icons.skip_next,
                          size: 40.0,
                          color: Colors.grey[600],
                        ),
                        BlocBuilder<AspectRatioBloc, AspectRatioState>(
                          builder: (context, ratioModelState) {
                            return InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(ratioModelState.icon),
                              ),
                              onTap: () {
                                BlocProvider.of<UiBloc>(context)
                                    .hideShowAllTimer(addTime: true);
                                BlocProvider.of<UiBloc>(context)
                                    .add(UiEvents.showTop);
                                switch (ratioModelState.aspectRatioEvents) {
                                  case AspectRatioEvents.original:
                                    BlocProvider.of<AspectRatioBloc>(context)
                                        .add(AspectRatioState(
                                            16 / 9,
                                            Icons.crop_5_4,
                                            "16:9",
                                            AspectRatioEvents.sixteenByNine,
                                            true));
                                    break;
                                  case AspectRatioEvents.sixteenByNine:
                                    BlocProvider.of<AspectRatioBloc>(context)
                                        .add(AspectRatioState(
                                            4 / 3,
                                            Icons.crop_din,
                                            "4:3",
                                            AspectRatioEvents.fourByThree,
                                            true));
                                    break;
                                  case AspectRatioEvents.fourByThree:
                                    BlocProvider.of<AspectRatioBloc>(context)
                                        .add(AspectRatioState(
                                            0.0,
                                            Icons.aspect_ratio,
                                            "Original",
                                            AspectRatioEvents.original,
                                            true));
                                    break;
                                }
                              },
                            );
                          },
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
