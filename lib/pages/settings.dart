import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videos_sharing/pages/torrent.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage(
      {Key key, @required this.sharedPreferences, @required this.onThemeChange})
      : super(key: key);
  final SharedPreferences sharedPreferences;
  final VoidCallback onThemeChange;
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
              title: Text("Dark theme"),
              subtitle: Text("Reduce glare and improve night viewing"),
              value: widget.sharedPreferences.getBool("isDark") ?? false,
              onChanged: (value) {
                widget.sharedPreferences.setBool("isDark", value);
                widget.onThemeChange();
              }),
          RaisedButton(child: Text("torrentPage"),onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyAppO()));
          })
        ],
      ),
    );
  }
}
