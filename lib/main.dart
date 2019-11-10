import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_torrent_streamer/flutter_torrent_streamer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videos_sharing/model/link.dart';
import 'package:videos_sharing/pages/home.dart';
import 'package:videos_sharing/services/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dataString =
      await MethodChannel('haidar.channel.torrent').invokeMethod("intent");
  await TorrentStreamer.init();
  BaseDatabase baseDatabase = TorrentStreamerDatabase();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (dataString != null) {
    baseDatabase.insertLink(
      Link(id: Random().nextInt(99999), link: dataString),
    );
  }

  runApp(new MyApp(
    sharedPreferences: prefs,
    dataString: dataString,
    baseDatabase: baseDatabase,
  ));
}

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
