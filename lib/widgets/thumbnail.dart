import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:videos_sharing/pages/player.dart';

class VideoThumbnailWidget extends StatefulWidget {
  VideoThumbnailWidget({Key key, @required this.file}) : super(key: key);
  final FileSystemEntity file;
  @override
  State<StatefulWidget> createState() {
    return _VideoThumbnailWidgetState();
  }
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  Uint8List _image;
  final _flutterVideoCompress = FlutterVideoCompress();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => _getThumbnail(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Card(
          child: _image != null
              ? Image.memory(
                  _image,
                  width: 100.0,
                  height: 48.0,
                  fit: BoxFit.cover,
                )
              : CircularProgressIndicator()),
      title: Text(widget.file.path.split('/').last),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerPage(videoUrl: widget.file.path),
          ),
        );
      },
    );
  }

  _getThumbnail() {
    _flutterVideoCompress
        .getThumbnail(
      widget.file.path,
      quality: 5,
      position: -1,
    )
        .then((thumbnail) {
      setState(() {
        _image = thumbnail;
      });
    });
  }
}
