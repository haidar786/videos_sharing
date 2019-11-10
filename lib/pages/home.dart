import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:videos_sharing/model/link.dart';
import 'package:videos_sharing/pages/settings.dart';
import 'package:videos_sharing/services/database.dart';

class HomePage extends StatefulWidget {
  HomePage(
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
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Media list"),
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => <PopupMenuEntry<int>>[
              PopupMenuItem(
                value: 1,
                child: Text("Settings"),
              ),
            ],
            onSelected: (value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    sharedPreferences: widget.sharedPreferences,
                    onThemeChange: widget.onThemeChange,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Link>>(
        future: _retrieveLinks(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: snapshot.data.length == 0
                    ? Center(
                        child: Text("Nothing to show."),
                      )
                    : ListView(
                        children: snapshot.data.map((element) {
                          return ListTile(
                            title: Text(element.id.toString()),
                            subtitle: Text(element.link),
                          );
                        }).toList(),
                      ),
              );
          }
          return Text("unreachable");
        },
      ),
    );
  }

  Future<List<Link>> _retrieveLinks() async {
    final Database db = await widget.baseDatabase.getInstance();

    final List<Map<String, dynamic>> maps = await db.query('links');

    return List.generate(maps.length, (i) {
      return Link(id: maps[i]['id'], link: maps[i]['link']);
    });
  }
}
