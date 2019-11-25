//import 'package:flutter/material.dart';
//import 'package:flutter_torrent_streamer/flutter_torrent_streamer.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:videos_sharing/pages/player.dart';
//
//class TorrentWidget extends StatefulWidget {
//  TorrentWidget({Key key, @required this.uri, @required this.sharedPreferences})
//      : super(key: key);
//  final String uri;
//  final SharedPreferences sharedPreferences;
//  @override
//  State<StatefulWidget> createState() {
//    return _TorrentWidgetState();
//  }
//}
//
//class _TorrentWidgetState extends State<TorrentWidget> {
//  bool _isDownloading = false;
//  bool _isStreamReady = false;
//  bool _isFetchingMeta = false;
//  bool _hasError = false;
//  Map<dynamic, dynamic> _status;
//
//  @override
//  void initState() {
//    _addTorrentListeners();
//    _startDownload();
//    super.initState();
//  }
//
////  @override
////  void dispose() {
////    TorrentStreamer.stop();
////    TorrentStreamer.removeEventListeners();
////    super.dispose();
////  }
//
//  @override
//  Widget build(BuildContext context) {
//    var theme = Theme.of(context);
//    return Column(
//      children: <Widget>[
//        ListTile(
//            title: Text("Uri"),
//            subtitle: Row(
//              children: <Widget>[
//                Text('Speed: ${_toKBPS(_speed)} KB/s  '),
//                Icon(
//                  Icons.fiber_manual_record,
//                  size: 12.0,
//                  color:
//                      _isStreamReady ? theme.primaryColor : theme.disabledColor,
//                )
//              ],
//            ),
//            trailing: Icon(Icons.delete),
//            onTap: () {
//              _isStreamReady
//                  ? _playVideo()
//                  : Scaffold.of(context).showSnackBar(
//                      SnackBar(
//                        content: Text("Stream does not ready yet"),
//                      ),
//                    );
//            }),
//        Padding(
//          padding: const EdgeInsets.symmetric(horizontal: 16.0),
//          child: Row(
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.only(right: 12.0),
//                child:
//                    Text('Buffering: ${_progress.floorToDouble().toString()}%'),
//              ),
//              Expanded(
//                child: LinearProgressIndicator(
//                    value: !_isFetchingMeta ? _progress / 100 : null),
//              ),
//            ],
//          ),
//        ),
//        Divider(),
//      ],
//    );
//  }
//
//  _playVideo() async {
//    await TorrentStreamer.getVideoPath().then((path) {
//      bool isExternalPlayer =
//          (widget.sharedPreferences.getBool("isExternalPlayer") ?? false)
//              ? true
//              : false;
//      isExternalPlayer
//          ? TorrentStreamer.launchVideo()
//          : Navigator.push(
//              context,
//              MaterialPageRoute(
//                builder: (context) => VideoPlayerPage(
//                  videoUrl: path,
//                ),
//              ),
//            );
//    });
//  }
//
//  void _addTorrentListeners() {
//    TorrentStreamer.addEventListener('started', (_) {
//      if (mounted) {
//        setState(() {
//          _isDownloading = true;
//          _isFetchingMeta = true;
//        });
//      }
//    });
//
//    TorrentStreamer.addEventListener('prepared', (_) {
//      setState(() {
//        _isDownloading = true;
//        _isFetchingMeta = false;
//      });
//    });
//
//    TorrentStreamer.addEventListener('progress', (data) {
//      setState(() => _status = data);
//    });
//
//    TorrentStreamer.addEventListener('ready', (_) {
//      setState(() => _isStreamReady = true);
//    });
//
//    TorrentStreamer.addEventListener('stopped', (_) {
//      _resetState();
//    });
//
//    TorrentStreamer.addEventListener('error', (_) {
//      setState(() => _hasError = true);
//    });
//  }
//
//  void _resetState() {
//    if (mounted) {
//      setState(() {
//        _isDownloading = false;
//        _isStreamReady = false;
//        _isFetchingMeta = false;
//        _hasError = false;
//        _status = null;
//      });
//    }
//  }
//
//  Future<void> _cleanDownloads(BuildContext context) async {
//    await TorrentStreamer.clean();
//    Scaffold.of(context)
//        .showSnackBar(SnackBar(content: Text('Cleared torrent cache!')));
//  }
//
//  Future<void> _startDownload() async {
//    await TorrentStreamer.stop();
//    await TorrentStreamer.start(widget.uri);
//  }
//
//  bool get _isCompleted => _progress == 100;
//
//  double get _progress => _status != null ? _status['progress'] : 0;
//
//  double get _speed => _status != null ? _status['downloadSpeed'] : 0;
//
//  int _toKBPS(double bps) {
//    return ((bps / 1000)).floor();
//  }
//}
