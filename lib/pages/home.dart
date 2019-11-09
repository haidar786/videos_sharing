import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videos_sharing/pages/abc.dart';
import 'package:videos_sharing/pages/settings.dart';
import 'package:videos_sharing/pages/player.dart';
import 'package:videos_sharing/pages/torrent.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {Key key,
      @required this.sharedPreferences,
      @required this.onThemeChange,
      @required this.jsonIntent})
      : super(key: key);
  final SharedPreferences sharedPreferences;
  final VoidCallback onThemeChange;
  final jsonIntent;
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Media list"),
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => <PopupMenuEntry<int>>[
              PopupMenuItem(
                value: 1,
                child: Text("Settings"),
              ),
            ],
            onSelected: (value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    sharedPreferences: widget.sharedPreferences,
                    onThemeChange: widget.onThemeChange,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          RaisedButton(
              child: Text("Blue"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerPage(
                      videoUrl:
                          "https://flutter.github.io/assets-for-api-docs/videos/butterfly.mp4",
                    ),
                  ),
                );
              }),
          RaisedButton(
              child: Text("Black"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAppO()),
                );
              }),
          RaisedButton(
              child: Text("Orange"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TestStuffs(jsonIntent: widget.jsonIntent),
                  ),
                );
              }),
        ],
      )),
    );
  }
}
