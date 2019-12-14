import 'package:flutter/material.dart';
import 'package:videos_sharing/model/video_files.dart';
import 'package:videos_sharing/widgets/video_item.dart';

class VideosPage extends StatelessWidget {
  VideosPage({Key key, @required this.files, @required this.folderName})
      : super(key: key);
  final List<Files> files;
  final String folderName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(folderName),
      ),
      body: ListView(
        children: files.map((video) {
          return VideoItems(video: video);
        }).toList(),
      ),
    );
  }
}
