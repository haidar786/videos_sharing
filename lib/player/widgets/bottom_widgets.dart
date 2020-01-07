import 'package:flutter/material.dart';
import 'package:videos_sharing/player/widgets/player_controllers.dart';
import 'package:videos_sharing/player/widgets/seeking.dart';

class BottomPlayerWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          color: Colors.black.withOpacity(0.5),
          child: Column(
            children: <Widget>[
              Seeking(),
              PlayerControllerWidget(),
            ],
          ),
        )
      ],
    );
  }
}
