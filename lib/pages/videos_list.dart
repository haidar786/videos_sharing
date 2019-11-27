import 'package:flutter/material.dart';
import 'package:videos_sharing/model/video_files.dart';

class VideosPage extends StatefulWidget {
  VideosPage({Key key, @required this.files, @required this.folderName})
      : super(key: key);
  final List<Files> files;
  final String folderName;

  @override
  State<StatefulWidget> createState() {
    return _VideosPageState();
  }
}

class _VideosPageState extends State<VideosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName),
      ),
      body: ListView(
        children: widget.files.map((video) {
          return ListTile(
            title: Text(video.displayName),
            onTap: () {

            },
          );
        }).toList(),
      ),
    );
  }
}
