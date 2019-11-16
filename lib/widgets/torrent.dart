import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer/flutter_torrent_streamer.dart';

class TorrentWidget extends StatefulWidget {
  TorrentWidget({Key key, @required this.uri}) : super(key: key);
  final String uri;
  @override
  State<StatefulWidget> createState() {
    return _TorrentWidgetState();
  }
}

class _TorrentWidgetState extends State<TorrentWidget> {
  bool _isDownloading = false;
  bool _isStreamReady = false;
  bool _isFetchingMeta = false;
  bool _hasError = false;
  Map<dynamic, dynamic> _status;

  @override
  void initState() {
    _addTorrentListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text("Uri"),
          subtitle: Text(widget.uri),
          trailing: Icon(Icons.delete),
          onTap: () {},
        ),
        Divider()
      ],
    );
  }

  void _addTorrentListeners() {
    TorrentStreamer.addEventListener('started', (_) {
      if (mounted) {
        setState(() {
          _isDownloading = true;
          _isFetchingMeta = true;
        });
      }
    });

    TorrentStreamer.addEventListener('prepared', (_) {
      setState(() {
        _isDownloading = true;
        _isFetchingMeta = false;
      });
    });

    TorrentStreamer.addEventListener('progress', (data) {
      setState(() => _status = data);
    });

    TorrentStreamer.addEventListener('ready', (_) {
      setState(() => _isStreamReady = true);
    });

    TorrentStreamer.addEventListener('stopped', (_) {
      _resetState();
    });

    TorrentStreamer.addEventListener('error', (_) {
      setState(() => _hasError = true);
    });
  }

  void _resetState() {
    if (mounted) {
      setState(() {
        _isDownloading = false;
        _isStreamReady = false;
        _isFetchingMeta = false;
        _hasError = false;
        _status = null;
      });
    }
  }

  Future<void> _cleanDownloads(BuildContext context) async {
    await TorrentStreamer.clean();
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Cleared torrent cache!')));
  }

  Future<void> _startDownload() async {
    await TorrentStreamer.stop();
    await TorrentStreamer.start(widget.uri);
  }

  bool get isCompleted => progress == 100;

  double get progress => _status != null ? _status['progress'] : 0;

  double get speed => _status != null ? _status['downloadSpeed'] : 0;

  int _toKBPS(double bps) {
    return ((bps / 1000)).floor();
  }
}
