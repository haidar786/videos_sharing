import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:videos_sharing/app/home/pages/home.dart';
import 'package:videos_sharing/app/home/widgets/backdrop/backdrop_options.dart';
import 'package:videos_sharing/app/home/widgets/backdrop/scales.dart';
import 'package:videos_sharing/app/home/widgets/backdrop/themes.dart';
import 'package:videos_sharing/app/home/widgets/backdrop/updater.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class MyApp extends StatefulWidget {
  const MyApp({
    Key key,
    this.updateUrlFetcher,
    this.onSendFeedback,
    this.testMode = false,
  }) : super(key: key);

  final UpdateUrlFetcher updateUrlFetcher;
  final VoidCallback onSendFeedback;
  final bool testMode;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BackdropOptions _options;
  Timer _timeDilationTimer;

  @override
  void initState() {
    super.initState();
    _options = BackdropOptions(
      themeMode: ThemeMode.system,
      textScaleFactor: kAllGalleryTextScaleValues[0],
      timeDilation: timeDilation,
      platform: defaultTargetPlatform,
    );
  }

  @override
  void reassemble() {
    _options = _options.copyWith(platform: defaultTargetPlatform);
    super.reassemble();
  }

  @override
  void dispose() {
    _timeDilationTimer?.cancel();
    _timeDilationTimer = null;
    super.dispose();
  }

  void _handleOptionsChanged(BackdropOptions newOptions) {
    setState(() {
      if (_options.timeDilation != newOptions.timeDilation) {
        _timeDilationTimer?.cancel();
        _timeDilationTimer = null;
        if (newOptions.timeDilation > 1.0) {
          // We delay the time dilation change long enough that the user can see
          // that UI has started reacting and then we slam on the brakes so that
          // they see that the time is in fact now dilated.
          _timeDilationTimer = Timer(const Duration(milliseconds: 150), () {
            timeDilation = newOptions.timeDilation;
          });
        } else {
          timeDilation = newOptions.timeDilation;
        }
      }

      _options = newOptions;
    });
  }

  Widget _applyTextScaleFactor(Widget child) {
    return Builder(
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: _options.textScaleFactor.scale,
          ),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget home = HomePage(
      testMode: widget.testMode,
      optionsPage: OptionsPage(
        options: _options,
        onOptionsChanged: _handleOptionsChanged,
        onSendFeedback: widget.onSendFeedback ??
            () {
              launch('https://github.com/flutter/flutter/issues/new/choose',
                  forceSafariVC: false);
            },
      ),
    );

    if (widget.updateUrlFetcher != null) {
      home = Updater(
        updateUrlFetcher: widget.updateUrlFetcher,
        child: home,
      );
    }

    return MaterialApp(
      theme: kLightGalleryTheme.copyWith(platform: _options.platform),
      darkTheme: kDarkGalleryTheme.copyWith(platform: _options.platform),
      themeMode: _options.themeMode,
      debugShowCheckedModeBanner: false,
      title: 'Apps Gallery',
      color: Colors.grey,
      builder: (BuildContext context, Widget child) {
        return Directionality(
          textDirection: _options.textDirection,
          child: _applyTextScaleFactor(
            // Specifically use a blank Cupertino theme here and do not transfer
            // over the Material primary color etc except the brightness to
            // showcase standard iOS looks.
            Builder(builder: (BuildContext context) {
              return CupertinoTheme(
                data: CupertinoThemeData(
                  brightness: Theme.of(context).brightness,
                ),
                child: child,
              );
            }),
          ),
        );
      },
      home: home,
    );
  }
}
