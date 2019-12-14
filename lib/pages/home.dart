import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videos_sharing/model/files_and_folder.dart';
import 'package:videos_sharing/model/video_files.dart';
import 'package:videos_sharing/pages/files_and_folders.dart';
import 'package:videos_sharing/pages/settings.dart';
import 'package:videos_sharing/pages/torrent_history.dart';
import 'package:videos_sharing/pages/videos_list.dart';
import 'package:videos_sharing/services/database.dart';

class HomePage extends StatefulWidget {
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

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<FileModel> _videoModel;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Folders"),
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (popUpContext) => <PopupMenuEntry<int>>[
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
                    _scaffoldKey.currentContext,
                    MaterialPageRoute(
                      builder: (pageRouteContext) => TorrentHistory(
                          sharedPreferences: widget.sharedPreferences,
                          dataString: widget.dataString,
                          baseDatabase: widget.baseDatabase),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    _scaffoldKey.currentContext,
                    MaterialPageRoute(
                      builder: (pageRouteContext) => SettingsPage(
                        sharedPreferences: widget.sharedPreferences,
                        onThemeChange: widget.onThemeChange,
                      ),
                    ),
                  );
                  break;
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: ListView(
          children: <Widget>[
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: _getVideosFromStorage().length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Icon(
                      Icons.folder,
                    ),
                  ),
                  title: Text(_getVideosFromStorage()[index].folderName),
//                  subtitle: Text(_getVideosFromStorage()[index].files.length ==
//                          1
//                      ? _getVideosFromStorage()[index].files.length.toString() +
//                          " video"
//                      : _getVideosFromStorage()[index].files.length.toString() +
//                          " videos"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideosPage(
                            files: _getVideosFromStorage()[index].files,
                            folderName:
                                _getVideosFromStorage()[index].folderName),
                      ),
                    );
                  },
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Icon(
                  Icons.folder,
                ),
              ),
              title: Text("Internal Storage"),
              //subtitle: Text("internal storage"),
              onTap: () {
                Navigator.push(
                  _scaffoldKey.currentContext,
                  MaterialPageRoute(
                    builder: (context) {
                      return FilesAndFoldersPage(ffModel: _getInternalStorage(),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refresh() {
    setState(() {});
    return Future.value();
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

  FFModel _getInternalStorage() {
    List<Directory> directories = [];
    List<FileSystemEntity> files = [];
    Directory directory = Directory('/storage/emulated/0/');
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
