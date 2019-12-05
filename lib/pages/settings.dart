import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
          Divider(),
          SwitchListTile(
              title: Text("External player"),
              subtitle: Text("Use other apps player."),
              value:
                  widget.sharedPreferences.getBool("isExternalPlayer") ?? false,
              onChanged: (value) {
                widget.sharedPreferences.setBool("isExternalPlayer", value);
                widget.onThemeChange();
              }),
          Divider(),
        ],
      ),
    );
  }
}
