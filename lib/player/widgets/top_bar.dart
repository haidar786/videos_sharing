import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/player/bloc/ui_bloc.dart';
import 'package:videos_sharing/player/bloc/aspect_ratio_bloc.dart';
import 'package:videos_sharing/player/bloc/state/aspect_ratio.dart';
import 'package:videos_sharing/player/bloc/state/ui.dart';

class TopBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UiBloc, UiState>(
      builder: (BuildContext context, UiState uiState) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: uiState.showTop
              ? Column(
                  children: <Widget>[
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      actions: <Widget>[
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.lock_outline),
                          ),
                          onTap: () {},
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.subtitles),
                          ),
                          onTap: () {},
                        ),
                        BlocBuilder<AspectRatioBloc, AspectRatioState>(
                          builder: (context, ratioModelState) {
                            return InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(ratioModelState.icon),
                              ),
                              onTap: () {
                               BlocProvider.of<UiBloc>(context).hideShowAllTimer(addTime: true);
                               // BlocProvider.of<UiBloc>(context).hideShowOverlay();
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
                  ],
                )
              : SizedBox.shrink(),
        );
      },
    );
  }
}
