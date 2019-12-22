import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
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
  double _brightness = 1.0;

  @override
  void initState() {
    _initBrightness();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Brightness"),
            subtitle: Text("Change app brightness"),
            trailing: Container(
              width: mediaQuery.orientation == Orientation.portrait
                  ? mediaQuery.size.width / 2.2
                  : mediaQuery.size.width / 3,
              child: Slider(
                value: _brightness,
                max: 1.0,
                min: 0.0,
                onChanged: (double value) {
                  setState(() {
                    _brightness = value;
                  });
                  Screen.setBrightness(
                    value.clamp(0.1, 1.0),
                  );
                },
              ),
            ),
          ),
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
                setState(() {
                  widget.sharedPreferences.setBool("isExternalPlayer", value);
                });
              }),
          Divider(),
        ],
      ),
    );
  }

  void _initBrightness() async {
    await Screen.brightness.then((brightness) {
      setState(() {
        _brightness = brightness;
      });
    });
  }
}
