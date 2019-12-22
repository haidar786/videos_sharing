import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videos_sharing/pages/root.dart';
import 'package:videos_sharing/services/database.dart';

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
      home: RootPage(
          sharedPreferences: widget.sharedPreferences,
          onThemeChange: () {
            setState(() {});
          },
          dataString: widget.dataString,
          baseDatabase: widget.baseDatabase),
    );
  }

  ThemeData _changeTheme() {
    bool isDark =
        (widget.sharedPreferences.getBool("isDark") ?? false) ? true : false;
    return isDark
        ? ThemeData(brightness: Brightness.dark, primarySwatch: Colors.red)
        : ThemeData(brightness: Brightness.light, primarySwatch: Colors.indigo);
  }
}
