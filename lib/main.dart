import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videos_sharing/app.dart';
import 'package:videos_sharing/services/database.dart';

import 'bloc/delegate/bloc_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  var dataString =
      await MethodChannel('haidar.channel.torrent').invokeMethod("intent");
  BaseDatabase baseDatabase = TorrentStreamerDatabase();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(new MyApp(
      sharedPreferences: prefs,
      dataString: dataString,
      baseDatabase: baseDatabase));
}
