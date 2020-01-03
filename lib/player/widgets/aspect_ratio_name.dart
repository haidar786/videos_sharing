import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/player/bloc/aspect_ratio_bloc.dart';
import 'package:videos_sharing/player/bloc/state/aspect_ratio.dart';

class AspectRatioNameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AspectRatioBloc, AspectRatioState>(
      builder: (BuildContext context, AspectRatioState state) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: state.shouldVisible
              ? Text(
                  state.aspectRatioName,
                  style: TextStyle(color: Colors.white, fontSize: 40.0),
                )
              : SizedBox.shrink(),
        );
      },
    );
  }
}
