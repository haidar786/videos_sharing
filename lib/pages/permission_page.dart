import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videos_sharing/app.dart';
import 'package:videos_sharing/services/database.dart';

class PermissionPage extends StatelessWidget {
  PermissionPage(
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
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Grant permission"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              "Without Permission app won't run.",
              style: theme.textTheme.display1,
            ),
            RaisedButton(
                child: Text("Give Permission"),
                onPressed: () async {
                  bool isGranted = await _checkPermission();
                  isGranted
                      ? Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(
                                sharedPreferences: sharedPreferences,
                                dataString: dataString,
                                baseDatabase: baseDatabase),
                          ),
                        )
                      : Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Without Permission app won't run."),
                          ),
                        );
                })
          ],
        ),
      ),
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
