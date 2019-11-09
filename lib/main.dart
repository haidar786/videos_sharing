import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_torrent_streamer/flutter_torrent_streamer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videos_sharing/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var jsonIntent =
      await MethodChannel('haidar.channel.torrent').invokeMethod("intent");
  await TorrentStreamer.init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(new MyApp(
    sharedPreferences: prefs,
    jsonIntent: jsonIntent,
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key key, @required this.sharedPreferences, @required this.jsonIntent})
      : super(key: key);
  final SharedPreferences sharedPreferences;
  final jsonIntent;

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
        }, jsonIntent: widget.jsonIntent,
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
