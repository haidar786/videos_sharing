import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/player/bloc/brightness_bloc.dart';
import 'package:videos_sharing/player/bloc/state/brightness.dart';

class BrightnessContainerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          height: 10,
          width: mediaQuery.orientation == Orientation.landscape
              ? mediaQuery.size.height / 3.5
              : mediaQuery.size.width / 3,
          child: Transform.rotate(
            angle: -pi / 2,
            child: BlocBuilder<BrightnessBloc, BrightnessControllerState>(
              builder: (BuildContext context, BrightnessControllerState state) {
                return AnimatedOpacity(
                  opacity: state.shouldVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: LinearProgressIndicator(
                    value: state.currentBrightness,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
