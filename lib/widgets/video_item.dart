import 'package:flutter/material.dart';
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
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
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
    return ListTile(
      leading: _controller.value.initialized
          ? Container(
              width: 100.0,
              height: 56.0,
              child: VideoPlayer(_controller),
            )
          : CircularProgressIndicator(),
      title: Text(widget.video.file.path.split('/').last),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VideoPlayerPage(videoUrl: widget.video.file.path),
          ),
        );
      },
    );
  }
}
