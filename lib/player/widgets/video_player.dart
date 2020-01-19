import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srt_parser/srt_parser.dart';
import 'package:subtitle_wrapper_package/models/style/subtitle_style.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';
import 'package:video_player/video_player.dart';
import 'package:videos_sharing/player/bloc/aspect_ratio_bloc.dart';
import 'package:videos_sharing/player/bloc/controller_bloc.dart';
import 'package:videos_sharing/player/bloc/state/aspect_ratio.dart';
import 'package:videos_sharing/player/bloc/state/controller.dart';
import 'package:wakelock/wakelock.dart';

class VideoPlayerWidget extends StatefulWidget {
  VideoPlayerWidget(
      {Key key, @required this.videoPath, @required this.globalKey})
      : super(key: key);
  final String videoPath;
  final GlobalKey<ScaffoldState> globalKey;
  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerWidgetState();
  }
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  String srtData = '''1
00:02:26,407 --> 00:02:31,356  X1:100 X2:100 Y1:100 Y2:100
+ time to move on, <u><b><font color="#00ff00">Arman</font></b></u>.
- OK

2
00:02:31,567 --> 00:02:37,164 
+ Lukas is publishing his library.
- I like the man.
''';
  String vvtData =
"1 00:00:01.251 --> 00:00:03.963 line:14 align:middle - Ahoj, jmenuji se Steven M. R. Covey. 2 00:00:03.965 --> 00:00:06.631 line:14 align:middle Ve Speed of Trust jste se dozvěděli 3 00:00:06.633 --> 00:00:08.133 line:14 align:middle o tom, jak je důležitá důvěra 4 00:00:08.135 --> 00:00:11.721 line:13 align:middle a proč je to jediná věc, která dokáže vše změnit. 5 00:00:11.723 --> 00:00:14.848 line:13 align:middle Během následujících 52 týdnů se naučíte, jak";
  @override
  void initState() {
    _getSubUrl();
    Wakelock.enable();
    // SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ControllerBloc, PlayerControllerState>(
      builder: (BuildContext context, PlayerControllerState state) {
        if (state.controller.value.initialized) {
          return BlocBuilder<AspectRatioBloc, AspectRatioState>(
            builder: (context, ratioModel) {
              return AspectRatio(
                aspectRatio: ratioModel.aspectRatio == 0.0
                    ? state.controller.value.aspectRatio
                    : ratioModel.aspectRatio,
                child: SubTitleWrapper(
                  videoChild: VideoPlayer(state.controller),
                  subtitleController: SubtitleController(
                   // subtitlesContent: utf8.decode(utf8.encode(vvtData)),
                  //  subtitleUrl: "https://duoidi6ujfbv.cloudfront.net/media/115/subtitles/5ccb556be8e7f.vtt",
                    subtitlesContent: _srtSub(),
                    showSubtitles: true,
                  ),
                  subtitleStyle:
                      SubtitleStyle(textColor: Colors.white, hasBorder: true,fontSize: 20.0),
                  videoPlayerController: state.controller,
                ),
              );
            },
          );
        } else {
          state.controller.addListener(() {
            if (state.controller.value.hasError) {
              print(state.controller.value.errorDescription);
              widget.globalKey.currentState.showSnackBar(
                SnackBar(
                  content: Text(
                      "This file has error or not supported by this video player."),
                ),
              );
            }
          });
          state.controller.initialize().then((_) {
            state.controller.play();
            setState(() {});
          });
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  String _getSubUrl() {
    int dotIndex = widget.videoPath.lastIndexOf('.');
    String subUrl = widget.videoPath.substring(1, dotIndex) + ".srt";
//    File(subUrl).readAsString().then((s){
//      print(s);
//    });
//    print(File(subUrl).readAsStringSync());
    return subUrl;
  }

  String _srtSub() {
    String vvtSub = "";
    List<Subtitle> subtitles = parseSrt(File(_getSubUrl()).readAsStringSync());
    for (Subtitle item in subtitles) {
      Duration startTime = Duration(milliseconds: item.range.begin);
      Duration endTime = Duration(milliseconds: item.range.end);
      vvtSub = vvtSub +
          startTime.toString().substring(0, 11).padLeft(12, '0') +
          " --> " +
          endTime.toString().substring(0, 11).padLeft(12, '0') +
          "\n";

      item.parsedLines.forEach((Line line) {
        return line.subLines.forEach((SubLine subLine) {
          vvtSub = vvtSub + subLine.rawString;
        });
      });

      vvtSub = vvtSub + "\n\n";
    }
    //print(vvtSub);
    return vvtSub;
  }

  @override
  void dispose() {
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }
}

//const dData = "WEBVTT - https://subtitletools.com  00:01:00.300 --> 00:01:01.640 [Banging]  00:01:04.850 --> 00:01:06.730 [HENRY] What the fuck is that?  00:01:06.850 --> 00:01:08.020 Jimmy?  00:01:08.100 --> 00:01:10.400 - [TOMMY] What is up? - [HENRY] Did I hit something?  00:01:10.520 --> 00:01:12.480 [TOMMY] What the fuck is that?  00:01:13.570 --> 00:01:15.440 [TOMMY] Maybe you got a flat?  00:01:16.700 --> 00:01:17.820 [HENRY] No.  00:01:19.240 --> 00:01:22.200 [TOMMY] What the fuck? You better pull over and see.  00:01:22.290 --> 00:01:23.620 [Banging]  00:01:30.170 --> 00:01:31.960 [Banging Continues]  00:01:48.440 --> 00:01:50.560 [TOMMY] He is still alive. You piece of shit!  00:01:50.650 --> 00:01:51.650 Die, motherfucker!  00:01:51.730 --> 00:01:52.690 [Grunting]  00:01:52.770 --> 00:01:54.190 [TOMMY] Look at me!  00:01:56.570 --> 00:01:58.360 [Multiple Gunshots]  00:02:03.160 --> 00:02:07.160 [HENRY] As far back as I can remember, I always wanted to be a gangster.  00:02:07.250 --> 00:02:09.750 [  Big Band Tune Plays, Background  ]  00:02:14.550 --> 00:02:17.050 [  I know I'd go from rags to riches  ]  00:02:20.680 --> 00:02:23.050 [  If you would only say you care  ]  00:02:27.270 --> 00:02:29.810 [  And though my pocket may be empty  ]  00:02:33.520 --> 00:02:35.400 [  I'd be a millionaire  ]  00:02:39.570 --> 00:02:42.570 [  My clothes may still be torn and tattered  ]  00:02:46.990 --> 00:02:48.250 [HENRY] To me...  00:02:48.660 --> 00:02:52.830 ... being a gangster was better than being president of the United States.  00:02:56.170 --> 00:02:59.420 Even before I went to the cabstand for an after-school job...  00:02:59.510 --> 00:03:01.880 ... I knew I wanted to be a part of them.  00:03:01.970 --> 00:03:06.310 It was there that I knew I belonged. To me, it meant being somebody...  00:03:06.510 --> 00:03:08.890 ... in a neighborhood full of nobodies.  00:03:09.020 --> 00:03:12.520 They weren't like anybody else. They did whatever they wanted.  00:03:12.730 --> 00:03:16.150 They parked in front of h";
