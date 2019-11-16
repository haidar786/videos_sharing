import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videos_sharing/model/link.dart';
import 'package:videos_sharing/pages/home.dart';
import 'package:videos_sharing/services/database.dart';
import 'package:flutter_torrent_streamer/flutter_torrent_streamer.dart';
class MyApp extends StatefulWidget {
  MyApp(
      {Key key,
      @required this.sharedPreferences,
      @required this.dataString,
      @required this.baseDatabase})
      : super(key: key);
  final SharedPreferences sharedPreferences;
  final dataString;
  final BaseDatabase baseDatabase;

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    if (widget.dataString != null) {
      widget.baseDatabase.insertLink(
        Link(link: widget.dataString),
      );
    }
    _initializeStreamer();
    super.initState();
  }

  @override
  void dispose() {
    _disposeStreamer();
    super.dispose();
  }

  _initializeStreamer() async {
    await TorrentStreamer.init();
  }

  _disposeStreamer() async {
    await TorrentStreamer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: _changeTheme(),
      home: HomePage(
        sharedPreferences: widget.sharedPreferences,
        onThemeChange: () {
          setState(() {});
        },
        dataString: widget.dataString,
        baseDatabase: widget.baseDatabase,
      ),
    );
  }

  ThemeData _changeTheme() {
    bool isDark =
        (widget.sharedPreferences.getBool("isDark") ?? false) ? true : false;
    return isDark
        ? ThemeData(brightness: Brightness.dark, primarySwatch: Colors.teal)
        : ThemeData(brightness: Brightness.light, primarySwatch: Colors.blue);
  }
}
