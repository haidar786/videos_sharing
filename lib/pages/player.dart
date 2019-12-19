import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/bloc/ratio/aspect_ratio_bloc.dart';
import 'package:videos_sharing/widgets/player/top_bar.dart';
import 'package:videos_sharing/widgets/player/video_player.dart';

class PlayerPage extends StatelessWidget {
  PlayerPage({Key key, @required this.videoPath}) : super(key: key);
  final String videoPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider<AspectRatioBloc>(
        create: (context) => AspectRatioBloc(),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            VideoPlayerWidget(videoPath: videoPath),
            Align(
              alignment: Alignment.topCenter,
              child: TopBarWidget(),
            )
          ],
        ),
      ),
    );
  }
}
