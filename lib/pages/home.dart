import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videos_sharing/model/video_files.dart';
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
      @required this.baseDatabase,
      @required this.paths})
      : super(key: key);
  final SharedPreferences sharedPreferences;
  final VoidCallback onThemeChange;
  final dataString;
  final BaseDatabase baseDatabase;
  final String paths;

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<VideoFiles> list;

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
                      builder: (context) => TorrentHistory(
                          sharedPreferences: widget.sharedPreferences,
                          dataString: widget.dataString,
                          baseDatabase: widget.baseDatabase),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(
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
      body: FutureBuilder<List<VideoFiles>>(
          future: _getVideos(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return CircularProgressIndicator();
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));
                return snapshot.data.length == 0
                    ? Center(child: Text("Nothing to show."))
                    : ListView(
                        children: snapshot.data.map((element) {
                          return ListTile(
                            leading: Icon(
                              Icons.folder,
                              size: 56.0,
                            ),
                            title: Text(element.folderName),
                            subtitle: Text(element.files.length == 1
                                ? element.files.length.toString() + " video"
                                : element.files.length.toString() + " videos"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideosPage(
                                      files: element.files,
                                      folderName: element.folderName),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      );

                break;
            }
            return Text("unreachable");
          }),
    );
  }

  Future<List<VideoFiles>> _getVideos() async {
    if (list == null) {
      var response = jsonDecode(widget.paths);
      var videoList = response as List;
      list = videoList
          .map<VideoFiles>((json) => VideoFiles.fromJson(json))
          .toList();
    }
    return list;
  }
}
