import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videos_sharing/pages/home.dart';
import 'package:videos_sharing/pages/permission_page.dart';
import 'package:videos_sharing/services/database.dart';

class MyApp extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) {
        return ThemeData(
          primarySwatch: Colors.indigo,
          brightness: brightness,
        );
      },
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: FutureBuilder(
            future: _checkPermission(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                default:
                  if (snapshot.data) {
                    return HomePage(
                        sharedPreferences: sharedPreferences,
                        dataString: dataString,
                        baseDatabase: baseDatabase);
                  } else {
                    return PermissionPage(
                        sharedPreferences: sharedPreferences,
                        dataString: dataString,
                        baseDatabase: baseDatabase);
                  }
              }
            },
          ),
        );
      },
    );
  }

  Future<bool> _checkPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }

    return false;
  }
}

//class MyApp extends StatefulWidget {
//  MyApp(
//      {Key key,
//      @required this.sharedPreferences,
//      @required this.dataString,
//      @required this.baseDatabase})
//      : super(key: key);
//  final SharedPreferences sharedPreferences;
//  final dataString;
//  final BaseDatabase baseDatabase;
//
//  @override
//  State<StatefulWidget> createState() {
//    return _MyAppState();
//  }
//}
//
//class _MyAppState extends State<MyApp> {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      debugShowCheckedModeBanner: false,
//      theme: _changeTheme(),
//      home: FutureBuilder(
//        future: _checkPermission(),
//        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//          switch (snapshot.connectionState) {
//            case ConnectionState.waiting:
//              return Scaffold(
//                body: Center(
//                  child: CircularProgressIndicator(),
//                ),
//              );
//            default:
//              if (snapshot.data) {
//                return HomePage(
//                    sharedPreferences: widget.sharedPreferences,
//                    onThemeChange: () {
//                      setState(() {});
//                    },
//                    dataString: widget.dataString,
//                    baseDatabase: widget.baseDatabase);
//              } else {
//                return PermissionPage(
//                    sharedPreferences: widget.sharedPreferences,
//                    dataString: widget.dataString,
//                    baseDatabase: widget.baseDatabase);
//              }
//          }
//        },
//      ),
//    );
//  }
//
//  ThemeData _changeTheme() {
//    bool isDark =
//        (widget.sharedPreferences.getBool("isDark") ?? false) ? true : false;
//    return isDark
//        ? ThemeData(brightness: Brightness.dark, primarySwatch: Colors.cyan)
//        : ThemeData(brightness: Brightness.light, primarySwatch: Colors.cyan);
//  }
//
//  Future<bool> _checkPermission() async {
//    PermissionStatus permission = await PermissionHandler()
//        .checkPermissionStatus(PermissionGroup.storage);
//    if (permission != PermissionStatus.granted) {
//      Map<PermissionGroup, PermissionStatus> permissions =
//          await PermissionHandler()
//              .requestPermissions([PermissionGroup.storage]);
//      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
//        return true;
//      }
//    } else {
//      return true;
//    }
//
//    return false;
//  }
//}
