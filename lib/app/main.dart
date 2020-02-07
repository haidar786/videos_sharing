import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videos_sharing/app/home/app_.dart';
import 'package:videos_sharing/torrent/database/database.dart';

import '../bloc/delegate/bloc_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  var dataString =
      await MethodChannel('haidar.channel.torrent').invokeMethod("intent");
  BaseDatabase baseDatabase = TorrentStreamerDatabase();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}
//
//class Test extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        body: Row(
//          children: <Widget>[
//            Text(
//              '420 Posts',
//              style: TextStyle(color: Color(0xff666666)),
//            ),
//            VerticalDivider(
//              thickness: 2,
//              width: 20,
//              color: Colors.black,
//            ),
//            Text(
//              '420 Posts',
//              style: TextStyle(color: Color(0xff666666)),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//}
