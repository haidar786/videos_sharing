import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  VideoPlayerPage({Key key, @required this.videoUrl}) : super(key: key);
  final String videoUrl;
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController _controller;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
//      ..initialize().then((_) {
//        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//        setState(() {});
//      });
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _chewieController.dispose();
  }
}

//      body: Stack(
//        alignment: Alignment.topCenter,
//        children: <Widget>[
////          AspectRatio(
////            aspectRatio: aspectRatio,
////            child: Container(
////              color: Colors.black,
////            ),
////          ),
//          AspectRatio(
//            aspectRatio: 1.5,
//            child: Center(
//              child:
//                  Chewie(
//                      controller: _chewieController,
//                    )
//            ),
//          ),
//        ],
//      ),

//    var mediaQuery = MediaQuery.of(context);
//    var aspectRatio;
//    if (mediaQuery.orientation == Orientation.portrait) {
//      _chewieController.exitFullScreen();
//      aspectRatio = 1.5;
//    } else {
//      _chewieController.enterFullScreen();
//      aspectRatio = mediaQuery.size.aspectRatio;
//    }
