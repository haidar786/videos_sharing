import 'package:flutter/material.dart';
import 'package:videos_sharing/model/video_files.dart';
import 'package:videos_sharing/pages/player.dart';

class VideoItems extends StatelessWidget {
  VideoItems({Key key, @required this.video}) : super(key: key);
  final Files video;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: AspectRatio(
            aspectRatio: 1.5,
            child: Icon(
              Icons.music_video,
              size: 56.0,
            ),
          ),
        ),
        //),
        title: Text(video.file.path.split('/').last),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerPage(
                videoUrl: video.file.path,
                mediaQuery: mediaQuery,
                videoName: video.file.path.split('/').last,
              ),
            ),
          );
        });
  }
}
//class VideoItem extends StatefulWidget {
//  VideoItem({Key key, @required this.video}) : super(key: key);
//  final Files video;
//  @override
//  State<StatefulWidget> createState() {
//    return _VideoItemState();
//  }
//}
//
//class _VideoItemState extends State<VideoItem> {
//  @override
//  Widget build(BuildContext context) {
//    var mediaQuery = MediaQuery.of(context);
//    return ListTile(
//        leading: ClipRRect(
//          borderRadius: BorderRadius.circular(10.0),
//          child: AspectRatio(
//            aspectRatio: 1.5,
//            child: Icon(
//              Icons.music_video,
//              size: 56.0,
//            ),
//          ),
//        ),
//        //),
//        title: Text(widget.video.file.path.split('/').last),
//        onTap: () {
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (context) => VideoPlayerPage(
//                videoUrl: widget.video.file.path,
//                mediaQuery: mediaQuery,
//                videoName: widget.video.file.path.split('/').last,
//              ),
//            ),
//          );
//        });
//  }
//}
