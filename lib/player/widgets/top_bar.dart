import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/player/bloc/UiBloc.dart';
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
                                switch (ratioModelState.aspectRatioEvents) {
                                  case AspectRatioEvents.original:
                                    BlocProvider.of<AspectRatioBloc>(context)
                                        .add(AspectRatioEvents.sixteenByNine);
                                    break;
                                  case AspectRatioEvents.sixteenByNine:
                                    BlocProvider.of<AspectRatioBloc>(context)
                                        .add(AspectRatioEvents.fourByThree);
                                    break;
                                  case AspectRatioEvents.fourByThree:
                                    BlocProvider.of<AspectRatioBloc>(context)
                                        .add(AspectRatioEvents.original);
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
