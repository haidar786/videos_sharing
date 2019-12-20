import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/bloc/player/aspect_ratio_bloc.dart';
import 'package:videos_sharing/bloc/player/controller_bloc.dart';
import 'package:videos_sharing/widgets/player/aspect_ratio_name.dart';
import 'package:videos_sharing/widgets/player/player_controllers.dart';
import 'package:videos_sharing/widgets/player/rotate.dart';
import 'package:videos_sharing/widgets/player/top_bar.dart';
import 'package:videos_sharing/widgets/player/video_player.dart';

class PlayerPage extends StatelessWidget {
  PlayerPage({Key key, @required this.videoPath}) : super(key: key);
  final String videoPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: MultiBlocProvider(
          providers: [
            BlocProvider<AspectRatioBloc>(
              create: (context) => AspectRatioBloc(),
            ),
            BlocProvider<ControllerBloc>(
              create: (BuildContext context){
                return ControllerBloc(videoPath);
              },
            )
          ],
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              VideoPlayerWidget(videoPath: videoPath),
              Align(
                alignment: Alignment.topCenter,
                child: TopBarWidget(),
              ),
              Align(
                alignment: Alignment.center,
                child: AspectRatioNameWidget(),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: RotateWidget(),
              ),
              Align(
                alignment: Alignment.center,
                child: PlayerControllerWidget(),
              )
            ],
          ),
        ));
  }
}
