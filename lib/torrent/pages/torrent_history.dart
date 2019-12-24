import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_torrent_flutter/simple_torrent_flutter.dart';
import 'package:simple_torrent_flutter/torrent_Session_status.dart';
import 'package:sqflite/sqflite.dart';
import 'package:videos_sharing/torrent/database/database.dart';
import 'package:videos_sharing/torrent/model/link.dart';


class TorrentHistory extends StatefulWidget {
  TorrentHistory(
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
    return _TorrentHistoryState();
  }
}

class _TorrentHistoryState extends State<TorrentHistory>
    with BaseSimpleListeners {
  SimpleTorrentFlutter _simpleTorrentFlutter;
  @override
  void initState() {
    _simpleTorrentFlutter = SimpleTorrentFlutter(SimpleListener());
    _simpleTorrentFlutter.simpleListener = this;
    if (widget.dataString != null) {
      //_simpleTorrentFlutter.startTorrent(widget.dataString);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Torrents List"),
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
              return snapshot.data.length == 0
                  ? Center(
                      child: Text("Nothing to show."),
                    )
                  : ListView(
                      children: snapshot.data.map((element) {
                        return ListTile(
                          title: Text("Uri"),
                          subtitle: Text(element.link),
                          onTap: () async {},
                        );
                      }).toList(),
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
      return Link(link: maps[i]['link']);
    });
  }

  @override
  void onAddTorrent(TorrentSessionStatus value) {
    // TODO: implement onAddTorrent
  }

  @override
  void onBlockUploaded(TorrentSessionStatus value) {
    // TODO: implement onBlockUploaded
  }

  @override
  void onMetadataFailed(TorrentSessionStatus value) {
    // TODO: implement onMetadataFailed
  }

  @override
  void onMetadataReceived(TorrentSessionStatus value) {
    // TODO: implement onMetadataReceived
  }

  @override
  void onPieceFinished(TorrentSessionStatus value) {
    widget.baseDatabase.insertLink(
      Link(link: value.magnetUri),
    );
    setState(() {});
  }

  @override
  void onTorrentDeleteFailed(TorrentSessionStatus value) {
    // TODO: implement onTorrentDeleteFailed
  }

  @override
  void onTorrentDeleted(TorrentSessionStatus value) {
    // TODO: implement onTorrentDeleted
  }

  @override
  void onTorrentError(TorrentSessionStatus value) {
    // TODO: implement onTorrentError
  }

  @override
  void onTorrentFinished(TorrentSessionStatus value) {
    // TODO: implement onTorrentFinished
  }

  @override
  void onTorrentPaused(TorrentSessionStatus value) {
    // TODO: implement onTorrentPaused
  }

  @override
  void onTorrentRemoved(TorrentSessionStatus value) {
    // TODO: implement onTorrentRemoved
  }

  @override
  void onTorrentResumed(TorrentSessionStatus value) {
    // TODO: implement onTorrentRemoved
  }

}
