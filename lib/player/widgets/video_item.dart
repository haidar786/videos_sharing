import 'package:flutter/material.dart';
import 'package:videos_sharing/player/model/video_files.dart';
import 'package:videos_sharing/player/pages/player.dart';

class VideoItems extends StatelessWidget {
  VideoItems({Key key, @required this.video}) : super(key: key);
  final Files video;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return ListTile(
        leading: Icon(
          Icons.videocam,
        ),
        //),
        title: Text(video.file.path.split('/').last),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayerPage(videoPath: video.file.path)
//                  VideoPlayerPage(
//                videoUrl: video.file.path,
//                mediaQuery: mediaQuery,
//                videoName: video.file.path.split('/').last,
//              ),
                ),
          );
        });
  }
}
