import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key key, @required this.sharedPreferences}) : super(key: key);
  final SharedPreferences sharedPreferences;

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
              value: sharedPreferences.getBool("isDark") ?? false,
              onChanged: (value) {
                DynamicTheme.of(context).setBrightness(
                    Theme.of(context).brightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark);
              }),
          Divider(),
          SwitchListTile(
              title: Text("External player"),
              subtitle: Text("Use other apps player."),
              value: sharedPreferences.getBool("isExternalPlayer") ?? false,
              onChanged: (value) {
                sharedPreferences.setBool("isExternalPlayer", value);
              }),
          Divider(),
        ],
      ),
    );
  }
}
