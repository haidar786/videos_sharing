import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/player/bloc/state/ui.dart';
import 'package:videos_sharing/player/bloc/ui_bloc.dart';
import 'package:videos_sharing/player/widgets/player_controllers.dart';
import 'package:videos_sharing/player/widgets/seeking.dart';

class BottomPlayerWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UiBloc, UiState>(
      builder: (BuildContext context, UiState state) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: state.showRotation
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      color: Colors.black.withOpacity(0.6),
                      child: Column(
                        children: <Widget>[
                          Seeking(isRotation: state.showRotation,),
                          PlayerControllerWidget(),
                        ],
                      ),
                    )
                  ],
                )
              : SizedBox.shrink(),
        );
      },
    );
  }
}
