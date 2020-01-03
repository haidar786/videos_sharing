import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/player/bloc/ui_bloc.dart';
import 'package:videos_sharing/player/bloc/state/ui.dart';

class RotateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return BlocBuilder<UiBloc, UiState>(
      builder: (BuildContext context, UiState uiState) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: uiState.showRotation
              ? Container(
                  alignment: Alignment.bottomCenter,
                  width: 56.0,
                  height: kToolbarHeight + 72.0,
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.screen_rotation,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                    onTap: () {
                      if (mediaQuery.orientation == Orientation.portrait) {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.landscapeLeft,
                          DeviceOrientation.landscapeRight
                        ]);
                      } else {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown
                        ]);
                      }
                    },
                  ),
                )
              : SizedBox.shrink(),
        );
      },
    );
  }
}
