import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_watcher/volume_watcher.dart';
import 'package:wakelock/wakelock.dart';

class VideoPlayerPage extends StatefulWidget {
  VideoPlayerPage(
      {Key key,
      @required this.videoUrl,
      @required this.videoName,
      @required this.mediaQuery})
      : super(key: key);
  final String videoUrl;
  final MediaQueryData mediaQuery;
  final String videoName;
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage>
    with SingleTickerProviderStateMixin {
  double vol = 0.0;
  VideoPlayerController _controller;
  AnimationController _animationController;
  bool _showOverlay = false;
  bool _showBottom = false;
  Timer _timer;
  Timer _volumeTimer;
  Timer _brightnessTimer;
  Timer _bottomTimer;
  Timer _seekForwardTimer;
  Timer _seekBackwardTimer;

  double _continuousValue = 0.0;

  double _opacity = 1.0;

  bool _isBrightnessChanging = false;
  bool _isVolumeChanging = false;
  bool _isForwardSeeking = false;
  bool _isBackwardSeeking = false;

  //num currentVolume = 0;
  num initVolume = 0;
  num maxVolume = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();

    Wakelock.enable();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        setState(() {
          _continuousValue = _controller.value.position.inSeconds.toDouble();
        });
      })
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  _hideShowOverlay() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      SystemChrome.setEnabledSystemUIOverlays([]);
      setState(() {
        _showOverlay = false;
      });
    } else if (_showOverlay) {
      SystemChrome.setEnabledSystemUIOverlays([]);
      setState(() {
        _showOverlay = false;
      });
    } else {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      setState(() {
        _showOverlay = true;
      });
      _timer = Timer(Duration(seconds: 2), onDoneLoading);
    }
  }

  onDoneLoading() {
    if (mounted && _controller.value.isPlaying) {
      setState(() {
        _showOverlay = false;
      });
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

  onBrightnessDone() {
    setState(() {
      _isBrightnessChanging = false;
    });
  }

  onVolumeDone() {
    setState(() {
      _isVolumeChanging = false;
    });
  }

  onSeekingDone() {
    setState(() {
      _showBottom = false;
    });
  }

  onSeekForwardDone() {
    setState(() {
      _isForwardSeeking = false;
    });
  }

  onSeekBackwardDone() {
    setState(() {
      _isBackwardSeeking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _controller.value.initialized
            ? Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Container(
                      color: Colors.black.withOpacity((_opacity - 1.0).abs()),
                    ),
                  ),
                  _showOverlay
                      ? AspectRatio(
                          aspectRatio: mediaQuery.size.aspectRatio,
                          child: Container(
                            color: Colors.black45,
                          ),
                        )
                      : Container(),
                  Align(
                    alignment: Alignment.topCenter,
                    child: _showOverlay
                        ? Container(
                            height: kToolbarHeight + 24.0,
                            child: AppBar(
                              backgroundColor: Colors.transparent,
                              title: Text(
                                widget.videoName,
                                style: TextStyle(fontSize: 15.0),
                              ),
                              actions: <Widget>[
                                InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.more_vert),
                                  ),
                                  onTap: () {},
                                )
                              ],
                            ),
                          )
                        : Container(),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: _showOverlay
                        ? Container(
                            alignment: Alignment.bottomCenter,
                            width: 56.0,
                            height: kToolbarHeight + 72.0,
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(
                                  Icons.screen_rotation,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                              ),
                              onTap: () {
                                if (mediaQuery.orientation ==
                                    Orientation.portrait) {
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.landscapeLeft,
                                    DeviceOrientation.landscapeRight
                                  ]);
                                } else {
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.portraitUp,
                                    DeviceOrientation.portraitDown
                                  ]);
                                }
                              },
                            ),
                          )
                        : Container(),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _isBrightnessChanging
                        ? Container(
                            height: 10,
                            width:
                                mediaQuery.orientation == Orientation.landscape
                                    ? mediaQuery.size.height / 4
                                    : mediaQuery.size.width / 3,
                            child: Transform.rotate(
                              angle: -pi / 2,
                              child: LinearProgressIndicator(
                                value: _opacity,
                              ),
                            ),
                          )
                        : Container(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _isVolumeChanging
                        ? Container(
                            height: 10,
                            width:
                                mediaQuery.orientation == Orientation.landscape
                                    ? mediaQuery.size.height / 4
                                    : mediaQuery.size.width / 3,
                            child: Transform.rotate(
                              angle: -pi / 2,
                              child: LinearProgressIndicator(
                                value: vol / maxVolume.toDouble(),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _isForwardSeeking
                        ? Container(
                            width: 100.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Shimmer.fromColors(
                                  period: Duration(milliseconds: 800),
                                  baseColor: Colors.white,
                                  highlightColor: Colors.black,
                                  child: Icon(
                                    Icons.fast_forward,
                                    color: Colors.white,
                                    size: 32.0,
                                  ),
                                ),
                                AutoSizeText(
                                  "+10 seconds",
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _isBackwardSeeking
                        ? Container(
                            width: 100.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Shimmer.fromColors(
                                  direction: ShimmerDirection.rtl,
                                  period: Duration(milliseconds: 800),
                                  baseColor: Colors.white,
                                  highlightColor: Colors.black,
                                  child: Icon(Icons.fast_rewind,size: 32.0,),
                                ),
                                AutoSizeText(
                                  "-10 seconds",
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: kToolbarHeight + 24.0),
                      child: GestureDetector(
                        child: Container(
                          color: Colors.red.withOpacity(0.0),
                          width: mediaQuery.size.width / 2,
                        ),
                        onVerticalDragUpdate: (update) {
                          vol -= (update.primaryDelta * maxVolume / 300);
                          vol = vol.clamp(0.0, maxVolume.toDouble());
                          print(vol / maxVolume);
                          VolumeWatcher.setVolume(vol);
                          setState(() {
                            vol = vol;
                          });
                        },
                        onVerticalDragStart: (details) {
                          initPlatformState();
                          setState(
                            () {
                              _isVolumeChanging = true;
                            },
                          );
                          if (_volumeTimer != null && _volumeTimer.isActive) {
                            _volumeTimer.cancel();
                          }
                        },
                        onVerticalDragEnd: (details) {
                          if (_volumeTimer != null && _volumeTimer.isActive) {
                            _volumeTimer.cancel();
                            _volumeTimer =
                                Timer(Duration(microseconds: 1000), onVolumeDone);
                          } else {
                            _volumeTimer =
                                Timer(Duration(milliseconds: 1000), onVolumeDone);
                          }
                        },
                        onDoubleTap: () {
                          setState(() {
                            _isForwardSeeking = true;
                          });
                          int seconds =
                              _controller.value.position.inSeconds + 10;
                          Duration duration = Duration(
                            hours: (seconds / 3600).floor(),
                            minutes: ((seconds % 3600) / 60).floor(),
                            seconds: (seconds % 60).floor(),
                          );
                          _controller.seekTo(duration);
                          if (_seekForwardTimer != null &&
                              _seekForwardTimer.isActive) {
                            _seekForwardTimer.cancel();
                            _seekForwardTimer =
                                Timer(Duration(milliseconds: 600), onSeekForwardDone);
                          } else {
                            _seekForwardTimer =
                                Timer(Duration(milliseconds: 600), onSeekForwardDone);
                          }
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: kToolbarHeight + 24.0),
                      child: GestureDetector(
                        child: Container(
                          color: Colors.green.withOpacity(0.0),
                          width: mediaQuery.size.width / 2,
                        ),
                        onVerticalDragUpdate: (update) {
                          _opacity -= update.primaryDelta * 0.004;
                          _opacity = _opacity.clamp(0.0, 1.0);
                          print((_opacity - 1.0).abs());
                          setState(() {
                            _opacity = _opacity;
                          });
                        },
                        onVerticalDragStart: (details) {
                          setState(
                            () {
                              _isBrightnessChanging = true;
                            },
                          );
                          if (_brightnessTimer != null &&
                              _brightnessTimer.isActive) {
                            _brightnessTimer.cancel();
                          }
                        },
                        onVerticalDragEnd: (details) {
                          if (_brightnessTimer != null &&
                              _brightnessTimer.isActive) {
                            _brightnessTimer.cancel();
                            _brightnessTimer =
                                Timer(Duration(seconds: 1), onBrightnessDone);
                          } else {
                            _brightnessTimer =
                                Timer(Duration(seconds: 1), onBrightnessDone);
                          }
                        },
                        onDoubleTap: () {
                          setState(() {
                            _isBackwardSeeking = true;
                          });
                          int seconds =
                              _controller.value.position.inSeconds - 10;
                          Duration duration = Duration(
                            hours: (seconds / 3600).floor(),
                            minutes: ((seconds % 3600) / 60).floor(),
                            seconds: (seconds % 60).floor(),
                          );
                          _controller.seekTo(duration);
                          if (_seekBackwardTimer != null &&
                              _seekBackwardTimer.isActive) {
                            _seekBackwardTimer.cancel();
                            _seekBackwardTimer =
                                Timer(Duration(milliseconds: 600), onSeekBackwardDone);
                          } else {
                            _seekBackwardTimer =
                                Timer(Duration(milliseconds: 600), onSeekBackwardDone);
                          }
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: _showOverlay
                        ? _showCenterController(mediaQuery, theme)
                        : Container(),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _showOverlay || _showBottom
                        ? _showBottomControllers(context, mediaQuery)
                        : Container(),
                  ),
                ],
              )
            : Stack(
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    title: AutoSizeText(
                      widget.videoName,
                      maxLines: 1,
                    ),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator())
                ],
              ),
      ),
      onTap: _hideShowOverlay,
      onHorizontalDragUpdate: (update) {
        double a = _controller.value.position.inSeconds.toDouble();
        a += update.primaryDelta * 0.5;
        a = a.clamp(0.0, _controller.value.duration.inSeconds.toDouble());
        int seconds = a.toInt();
        Duration duration = Duration(
          hours: (seconds / 3600).floor(),
          minutes: ((seconds % 3600) / 60).floor(),
          seconds: (seconds % 60).floor(),
        );
        print(duration);
        _controller.seekTo(duration);
      },
      onHorizontalDragStart: (details) {
        setState(() {
          _showBottom = true;
        });
        if (_bottomTimer != null && _bottomTimer.isActive) {
          _bottomTimer.cancel();
        }
      },
      onHorizontalDragEnd: (details) {
        if (_bottomTimer != null && _bottomTimer.isActive) {
          _bottomTimer.cancel();
          _bottomTimer = Timer(Duration(seconds: 1), onSeekingDone);
        } else {
          _bottomTimer = Timer(Duration(seconds: 1), onSeekingDone);
        }
      },
    );
  }

  Widget _showBottomControllers(
      BuildContext context, MediaQueryData mediaQuery) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: AutoSizeText(
                format(_controller.value.position),
                style: TextStyle(color: Colors.white, fontSize: 12.0),
              ),
            ),
            Expanded(
              child: Slider(
                value: _continuousValue,
                label: _continuousValue.toString(),
                min: 0.0,
                max: _controller.value.duration.inSeconds.toDouble(),
                onChanged: (double value) {
                  int seconds = value.toInt();
                  Duration duration = Duration(
                    hours: (seconds / 3600).floor(),
                    minutes: ((seconds % 3600) / 60).floor(),
                    seconds: (seconds % 60).floor(),
                  );
                  _controller.seekTo(duration);
                },
                onChangeStart: (value) {
                  if (_timer != null && _timer.isActive) {
                    _timer.cancel();
                  }
                },
                onChangeEnd: (value) {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AutoSizeText(
                format(_controller.value.duration),
                style: TextStyle(color: Colors.white, fontSize: 12.0),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _showCenterController(MediaQueryData mediaQuery, ThemeData theme) {
    return Container(
      width: mediaQuery.orientation == Orientation.portrait
          ? mediaQuery.size.width
          : mediaQuery.size.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            Icons.skip_previous,
            size: 36.0,
            color: Colors.grey[600],
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedIcon(
                icon: AnimatedIcons.pause_play,
                progress: _animationController,
                size: 52.0,
                color: Colors.white,
              ),
            ),
            onTap: () {
              _controller.value.isPlaying
                  ? _animationController.forward()
                  : _animationController.reverse();
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
                if (_timer != null && _timer.isActive) {
                  _timer.cancel();
                  _timer = Timer(Duration(seconds: 1), onDoneLoading);
                } else {
                  _timer = Timer(Duration(seconds: 1), onDoneLoading);
                }
              }
              setState(() {});
            },
          ),
          Icon(
            Icons.skip_next,
            size: 36.0,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Future<void> initPlatformState() async {
    num initVolume = await VolumeWatcher.getCurrentVolume;
    num maxVolume = await VolumeWatcher.getMaxVolume;

    if (!mounted) return;

    setState(() {
      this.initVolume = initVolume;
      this.maxVolume = maxVolume;
      vol = initVolume.toDouble();
    });
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _controller.dispose();
    _animationController.dispose();
  }
}
