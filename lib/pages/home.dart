import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videos_sharing/model/video_files.dart';
import 'package:videos_sharing/pages/settings.dart';
import 'package:videos_sharing/pages/torrent_history.dart';
import 'package:videos_sharing/pages/videos_list.dart';
import 'package:videos_sharing/services/database.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage(
      {Key key,
      @required this.sharedPreferences,
      @required this.onThemeChange,
      @required this.dataString,
      @required this.baseDatabase})
      : super(key: key);
  final SharedPreferences sharedPreferences;
  final VoidCallback onThemeChange;
  final dataString;
  final BaseDatabase baseDatabase;

  List<FileModel> _videoModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Folders"),
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => <PopupMenuEntry<int>>[
              PopupMenuItem(
                value: 1,
                child: Text("Torrents"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Settings"),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context1) => TorrentHistory(
                          sharedPreferences: sharedPreferences,
                          dataString: dataString,
                          baseDatabase: baseDatabase),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context1) => SettingsPage(
                        sharedPreferences: sharedPreferences,
                        onThemeChange: onThemeChange,
                      ),
                    ),
                  );
                  break;
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _getVideosFromStorage().length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              Icons.folder,
              size: 64.0,
            ),
            title: Text(_getVideosFromStorage()[index].folderName),
            subtitle: Text(_getVideosFromStorage()[index].files.length == 1
                ? _getVideosFromStorage()[index].files.length.toString() +
                    " video"
                : _getVideosFromStorage()[index].files.length.toString() +
                    " videos"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideosPage(
                      files: _getVideosFromStorage()[index].files,
                      folderName: _getVideosFromStorage()[index].folderName),
                ),
              );
            },
          );
        },
      ),
    );
  }

  _getVideosFromStorage() {
    if (_videoModel == null) {
      List<FileModel> videoModel = [];
      List<String> directories = [];
      List<FileSystemEntity> files = [];
      Directory directory = Directory('/storage/emulated/0/');
      List<FileSystemEntity> allFiles =
          directory.listSync(recursive: true, followLinks: false);
      allFiles.forEach((file) {
        if (file.path.endsWith('.mp4')) {
          directories.add(file.parent.path);
          files.add(file);
        }
      });
      directories.toSet().toList().forEach((directory) {
        List<Files> videoFiles = [];
        Directory videoDirectory = Directory(directory);
        files = videoDirectory.listSync();
        files.forEach((file) {
          if (file.path.endsWith('.mp4')) {
            videoFiles.add(
              Files(file),
            );
          }
        });
        videoModel.add(
          FileModel(directory.split('/').last, videoFiles),
        );
      });
      _videoModel = videoModel;
    }
    return _videoModel;
  }
}

//class HomePage extends StatefulWidget {
//  HomePage(
//      {Key key,
//        @required this.sharedPreferences,
//        @required this.onThemeChange,
//        @required this.dataString,
//        @required this.baseDatabase})
//      : super(key: key);
//  final SharedPreferences sharedPreferences;
//  final VoidCallback onThemeChange;
//  final dataString;
//  final BaseDatabase baseDatabase;
//
//  @override
//  State<StatefulWidget> createState() {
//    return _HomePageState();
//  }
//}
//
//class _HomePageState extends State<HomePage> {
//  List<FileModel> _videoModel;
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Folders"),
//        actions: <Widget>[
//          PopupMenuButton<int>(
//            itemBuilder: (context) => <PopupMenuEntry<int>>[
//              PopupMenuItem(
//                value: 1,
//                child: Text("Torrents"),
//              ),
//              PopupMenuItem(
//                value: 2,
//                child: Text("Settings"),
//              ),
//            ],
//            onSelected: (value) {
//              switch (value) {
//                case 1:
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context1) => TorrentHistory(
//                          sharedPreferences: widget.sharedPreferences,
//                          dataString: widget.dataString,
//                          baseDatabase: widget.baseDatabase),
//                    ),
//                  );
//                  break;
//                case 2:
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context1) => SettingsPage(
//                        sharedPreferences: widget.sharedPreferences,
//                        onThemeChange: widget.onThemeChange,
//                      ),
//                    ),
//                  );
//                  break;
//              }
//            },
//          ),
//        ],
//      ),
//      body: FutureBuilder<List<FileModel>>(
//          future: _getVideosFromStorage(),
//          builder: (context, snapshot) {
//            switch (snapshot.connectionState) {
//              case ConnectionState.none:
//              case ConnectionState.waiting:
//                return CircularProgressIndicator();
//                break;
//              case ConnectionState.active:
//              case ConnectionState.done:
//                if (snapshot.hasError)
//                  return Center(
//                    child: Text('Error: ${snapshot.error}'),
//                  );
//                return snapshot.data.length == 0
//                    ? Center(
//                  child: Text("Nothing to show."),
//                )
//                    : ListView(
//                  children: snapshot.data.map((element) {
//                    return ListTile(
//                      leading: Icon(
//                        Icons.folder,
//                        size: 64.0,
//                      ),
//                      title: Text(element.folderName),
//                      subtitle: Text(element.files.length == 1
//                          ? element.files.length.toString() + " video"
//                          : element.files.length.toString() + " videos"),
//                      onTap: () {
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                            builder: (context) => VideosPage(
//                                files: element.files,
//                                folderName: element.folderName),
//                          ),
//                        );
//                      },
//                    );
//                  }).toList(),
//                );
//
//                break;
//            }
//            return Text("unreachable");
//          }),
//    );
//  }
//
//  Future<List<FileModel>> _getVideosFromStorage() async {
//    if (_videoModel == null) {
//      List<FileModel> videoModel = [];
//      List<String> directories = [];
//      List<FileSystemEntity> files = [];
//      Directory directory = Directory('/storage/emulated/0/');
//      List<FileSystemEntity> allFiles =
//      directory.listSync(recursive: true, followLinks: false);
//      allFiles.forEach((file) {
//        if (file.path.endsWith('.mp4')) {
//          directories.add(file.parent.path);
//          files.add(file);
//        }
//      });
//      directories.toSet().toList().forEach((directory) {
//        List<Files> videoFiles = [];
//        Directory videoDirectory = Directory(directory);
//        files = videoDirectory.listSync();
//        files.forEach((file) {
//          if (file.path.endsWith('.mp4')) {
//            videoFiles.add(
//              Files(file),
//            );
//          }
//        });
//        videoModel.add(
//          FileModel(directory.split('/').last, videoFiles),
//        );
//      });
//      _videoModel = videoModel;
//    }
//    return _videoModel;
//  }
//
//  _getInternalStorage() {
//    if (_videoModel == null) {
//      List<FileModel> fileModel = [];
//      List<Directory> directories = [];
//      List<FileSystemEntity> files = [];
//      Directory directory = Directory('/storage/emulated/0/');
//      List<FileSystemEntity> allFilesAndFolders =
//      directory.listSync(recursive: false, followLinks: false);
//      allFilesAndFolders.forEach((fileOrFolder) {
//        directories.add(fileOrFolder);
//        files.add(fileOrFolder);
//      });
//    }
//  }
//}
