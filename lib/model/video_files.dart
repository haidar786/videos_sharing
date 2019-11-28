import 'dart:io';

class VideoModel {
  List<FileSystemEntity> files;
  String folderName;

  VideoModel(this.folderName, this.files);
}