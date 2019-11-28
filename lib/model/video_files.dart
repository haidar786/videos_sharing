import 'dart:io';

import 'dart:typed_data';

class VideoModel {
  List<Files> files;
  String folderName;

  VideoModel(this.folderName, this.files);
}

class Files {
  FileSystemEntity file;
  Uint8List uInt8listThumbnail;

  Files(this.file,this.uInt8listThumbnail);
}