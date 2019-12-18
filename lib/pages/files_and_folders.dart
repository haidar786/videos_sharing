import 'dart:io';

import 'package:flutter/material.dart';
import 'package:videos_sharing/model/files_and_folder.dart';
import 'package:videos_sharing/pages/player.dart';
import 'package:videos_sharing/pages/player_.dart';

class FilesAndFoldersPage extends StatelessWidget {
  FilesAndFoldersPage({Key key, @required this.ffModel}) : super(key: key);
  final FFModel ffModel;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Files"),
        ),
        body: ffModel.directories.length < 1 && ffModel.files.length < 1
            ? Center(
                child: Text("Empty Folder"),
              )
            : ListView(
                children: <Widget>[
                  ListView(
                    primary: false,
                    shrinkWrap: true,
                    children: ffModel.directories.map((element) {
                      return ListTile(
                        leading: Icon(
                          Icons.folder,
                        ),
                        title: Text(element.path.split('/').last),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilesAndFoldersPage(
                                  ffModel: _getInternalStorage(element.path)),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  ListView(
                    primary: false,
                    shrinkWrap: true,
                    children: ffModel.files.map((element) {
                      return ListTile(
                        leading: Icon(
                          Icons.insert_drive_file,
                        ),
                        title: Text(element.path.split('/').last),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
//                                return VideoPlayerPage(
//                                    videoUrl: element.path,
//                                    videoName: element.path.split('/').last,
//                                    mediaQuery: mediaQuery);
                              return PlayerPage(videoPath: element.path,);

                              }
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ));
  }

  FFModel _getInternalStorage(String path) {
    List<Directory> directories = [];
    List<FileSystemEntity> files = [];
    Directory directory = Directory(path);
    List<FileSystemEntity> allFilesAndFolders =
        directory.listSync(recursive: false, followLinks: false);
    allFilesAndFolders.forEach((fileSystemEntity) {
      if (fileSystemEntity.statSync().type == FileSystemEntityType.directory) {
        directories.add(fileSystemEntity);
      } else {
        files.add(fileSystemEntity);
      }
    });

    return FFModel(directories, files);
  }
}
