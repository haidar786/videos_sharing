import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/player/bloc/ui_bloc.dart';
import 'package:videos_sharing/player/bloc/aspect_ratio_bloc.dart';
import 'package:videos_sharing/player/bloc/brightness_bloc.dart';
import 'package:videos_sharing/player/bloc/controller_bloc.dart';
import 'package:videos_sharing/player/bloc/volume_bloc.dart';
import 'package:videos_sharing/player/widgets/aspect_ratio_name.dart';
import 'package:videos_sharing/player/widgets/bottom_widgets.dart';
import 'package:videos_sharing/player/widgets/brightness_container.dart';
import 'package:videos_sharing/player/widgets/seek_drag_container.dart';
import 'package:videos_sharing/player/widgets/volume_container.dart';
import 'package:videos_sharing/player/widgets/rotate.dart';
import 'package:videos_sharing/player/widgets/top_bar.dart';
import 'package:videos_sharing/player/widgets/video_player.dart';

class PlayerPage extends StatelessWidget {
  PlayerPage({Key key, @required this.videoPath}) : super(key: key);
  final String videoPath;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
   // var mediaQuery = MediaQuery.of(context);
    return Scaffold(
        key: _globalKey,
        backgroundColor: Colors.black,
        body: MultiBlocProvider(
          providers: [
            BlocProvider<AspectRatioBloc>(
              create: (BuildContext _) => AspectRatioBloc(),
            ),
            BlocProvider<ControllerBloc>(
              create: (BuildContext _) => ControllerBloc(videoPath),
            ),
            BlocProvider<VolumeBloc>(
              create: (BuildContext _) => VolumeBloc(),
            ),
            BlocProvider<BrightnessBloc>(
              create: (BuildContext _) => BrightnessBloc(),
            ),
            BlocProvider<UiBloc>(
              create: (BuildContext _) => UiBloc(),
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
              Align(
                alignment: Alignment.centerRight,
                child: VolumeContainerWidget(),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: BrightnessContainerWidget(),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: TopBarWidget(title: videoPath.split('/').last,),
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
                alignment: Alignment.bottomCenter,
                child: BottomPlayerWidgets(),
              )
            ],
          ),
        ));
  }
}
