import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/bloc/player/aspect_ratio_bloc.dart';
import 'package:videos_sharing/bloc/player/controller_bloc.dart';
import 'package:videos_sharing/widgets/player/aspect_ratio_name.dart';
import 'package:videos_sharing/widgets/player/bottom_widgets.dart';
import 'package:videos_sharing/widgets/player/seek_drag_container.dart';
import 'package:videos_sharing/widgets/player/player_controllers.dart';
import 'package:videos_sharing/widgets/player/right_container.dart';
import 'package:videos_sharing/widgets/player/rotate.dart';
import 'package:videos_sharing/widgets/player/top_bar.dart';
import 'package:videos_sharing/widgets/player/video_player.dart';

class PlayerPage extends StatelessWidget {
  PlayerPage({Key key, @required this.videoPath}) : super(key: key);
  final String videoPath;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        backgroundColor: Colors.black,
        body: MultiBlocProvider(
          providers: [
            BlocProvider<AspectRatioBloc>(
              create: (context) => AspectRatioBloc(),
            ),
            BlocProvider<ControllerBloc>(
              create: (BuildContext context) {
                return ControllerBloc(videoPath);
              },
            )
          ],
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              VideoPlayerWidget(
                videoPath: videoPath,
                globalKey: _globalKey,
              ),
              SeekDragContainer(),
//              Align(
//                alignment: Alignment.centerRight,
//                child: RightContainerWidget(),
//              ),
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
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomPlayerWidgets(),
              )
            ],
          ),
        ));
  }
}
