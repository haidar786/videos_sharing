import 'package:flutter/material.dart';
import 'package:videos_sharing/widgets/player/top_bar.dart';
import 'package:videos_sharing/widgets/player/video_player.dart';

class PlayerPage extends StatelessWidget {
  PlayerPage({Key key, @required this.videoPath}) : super(key: key);
  final String videoPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          VideoPlayerWidget(videoPath: videoPath),
          Align(
            alignment: Alignment.topCenter,
            child: TopBarWidget(),
          )
        ],
      ),
    );
  }
}
