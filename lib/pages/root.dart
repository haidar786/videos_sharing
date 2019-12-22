import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videos_sharing/pages/home.dart';
import 'package:videos_sharing/pages/permission_page.dart';
import 'package:videos_sharing/services/database.dart';

class RootPage extends StatefulWidget {
  RootPage(
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
    return _RootPage();
  }
}

class _RootPage extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                  sharedPreferences: widget.sharedPreferences,
                  onThemeChange: widget.onThemeChange,
                  dataString: widget.dataString,
                  baseDatabase: widget.baseDatabase);
//              return Backdrop(
//                frontLayer: HomePage(
//                    sharedPreferences: widget.sharedPreferences,
//                    onThemeChange: () {
//                      setState(() {});
//                    },
//                    dataString: widget.dataString,
//                    baseDatabase: widget.baseDatabase),
//                backLayer: null,
//                frontTitle: Text("front title"),
//                backTitle: Text("back title"),
//              );
            } else {
              return PermissionPage(
                  sharedPreferences: widget.sharedPreferences,
                  dataString: widget.dataString,
                  baseDatabase: widget.baseDatabase);
            }
        }
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
