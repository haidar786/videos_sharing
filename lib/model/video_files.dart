import 'dart:io';

class FileModel {
  List<Files> files;
  String folderName;

  FileModel(this.folderName, this.files);
}

class Files {
  FileSystemEntity file;

  Files(this.file);
}