import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/bloc/player/aspect_ratio_bloc.dart';
import 'package:videos_sharing/model/aspect_ratio_model.dart';

class TopBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
            BlocBuilder<AspectRatioBloc, AspectRatioModel>(
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
                            .add(AspectRatioEvents.twoBYOne);
                        break;
                      case AspectRatioEvents.twoBYOne:
                        BlocProvider.of<AspectRatioBloc>(context)
                            .add(AspectRatioEvents.fourByThree);
                        break;
                      case AspectRatioEvents.fourByThree:
                        BlocProvider.of<AspectRatioBloc>(context)
                            .add(AspectRatioEvents.sixteenByNine);
                        break;
                      case AspectRatioEvents.sixteenByNine:
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
    );
  }
}
