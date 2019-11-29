import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:videos_sharing/model/video_files.dart';
import 'package:videos_sharing/pages/player.dart';

class VideoItem extends StatefulWidget {
  VideoItem({Key key, @required this.video}) : super(key: key);
  final Files video;
  @override
  State<StatefulWidget> createState() {
    return _VideoItemState();
  }
}

class _VideoItemState extends State<VideoItem> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video.file.path)
      ..initialize().then((_) {
        //  _controller.setVolume(0.0);
        //   _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return VisibilityDetector(
      child: ListTile(
        leading:
        //Card(
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
          //child:
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: _controller.value.initialized
                  ? VideoPlayer(_controller)
                  : Icon(
                      Icons.music_video,
                      size: 56.0,
                    ),
            ),
          ),
        //),
        title: Text(widget.video.file.path.split('/').last),
        subtitle: _controller.value.initialized
            ? Text(_controller.dataSource)
            : Container(),
        onTap: () {
          _controller.value.initialized ?? _controller.pause();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VideoPlayerPage(videoUrl: widget.video.file.path, mediaQuery: mediaQuery,),
            ),
          );
        },
      ),
      key: Key("haidar"),
      onVisibilityChanged: (VisibilityInfo info) {
//        if (_controller.value.initialized) {
//          if (info.visibleFraction == 0.0) {
//            if(_controller.value.isPlaying) {
//              _controller.pause();
//            }
//          }else {
//            if (!_controller.value.isPlaying){
//              _controller.play();
//            }
//          }
//        }
      },
    );
  }
}
