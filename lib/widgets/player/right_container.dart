import 'dart:math';

import 'package:flutter/material.dart';
import 'package:volume_watcher/volume_watcher.dart';

class RightContainerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RightContainerWidget();
  }
}

class _RightContainerWidget extends State<RightContainerWidget> {
  double currentVolume = 8.0;
  double maxVolume = 15.0;

  @override
  void initState() {
    _initPlatformState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return GestureDetector(
      child: Container(
        width: mediaQuery.size.width / 2,
        height: mediaQuery.size.height,
        color: Colors.yellow.withOpacity(0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              height: 10,
              width: mediaQuery.orientation == Orientation.landscape
                  ? mediaQuery.size.height / 3.5
                  : mediaQuery.size.width / 3,
              child: Transform.rotate(
                angle: -pi / 2,
                child: LinearProgressIndicator(
                  value: currentVolume / maxVolume,
                ),
              ),
            ),
          ],
        ),
      ),
      onVerticalDragUpdate: (update) {
        currentVolume -= (update.primaryDelta * maxVolume / 300);
        currentVolume = currentVolume.clamp(0.0, maxVolume);
        print(currentVolume / maxVolume);
        VolumeWatcher.setVolume(currentVolume);
        setState(() {});
      },
      onVerticalDragStart: (details) {
        _initPlatformState();
//                      if (!_isLocked) {
//                        initPlatformState();
//                        setState(
//                              () {
//                            _isVolumeChanging = true;
//                          },
//                        );
//                        if (_volumeTimer != null && _volumeTimer.isActive) {
//                          _volumeTimer.cancel();
//                        }
//                      } else {
//                        _hideShowLockIcon();
//                      }
      },
      onVerticalDragEnd: (details) {
//                      if (!_isLocked) {
//                        if (_volumeTimer != null && _volumeTimer.isActive) {
//                          _volumeTimer.cancel();
//                          _volumeTimer = Timer(
//                              Duration(microseconds: 1000), onVolumeDone);
//                        } else {
//                          _volumeTimer = Timer(
//                              Duration(milliseconds: 1000), onVolumeDone);
//                        }
//                      }
      },
      onDoubleTap: () {
//                      if (!_isLocked) {
//                        setState(() {
//                          _isForwardSeeking = true;
//                        });
//                        int seconds =
//                            _controller.value.position.inSeconds + 10;
//                        Duration duration = Duration(
//                          hours: (seconds / 3600).floor(),
//                          minutes: ((seconds % 3600) / 60).floor(),
//                          seconds: (seconds % 60).floor(),
//                        );
//                        _controller.seekTo(duration);
//                        if (_seekForwardTimer != null &&
//                            _seekForwardTimer.isActive) {
//                          _seekForwardTimer.cancel();
//                          _seekForwardTimer = Timer(
//                              Duration(milliseconds: 600),
//                              onSeekForwardDone);
//                        } else {
//                          _seekForwardTimer = Timer(
//                              Duration(milliseconds: 600),
//                              onSeekForwardDone);
//                        }
//                      } else {
//                        _hideShowLockIcon();
//                      }
      },
    );
  }

  Future<void> _initPlatformState() async {
    num initVolume = await VolumeWatcher.getCurrentVolume;
    num maxVolume = await VolumeWatcher.getMaxVolume;

    if (!mounted) return;

    setState(() {
      this.maxVolume = maxVolume.toDouble();
      currentVolume = initVolume.toDouble();
    });
  }
}
