import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/player/bloc/ui_bloc.dart';
import 'package:videos_sharing/player/bloc/state/ui.dart';

class LockBlocWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UiBloc, UiState>(
      builder: (BuildContext context, UiState uiState) {
        if (uiState.showLock) {
          return LockWidget();
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

class LockWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LockWidgetState();
  }
}

class _LockWidgetState extends State<LockWidget> {
  Timer _timer;
  bool _showLock = true;

  @override
  void initState() {
    _hideLockTimer();
    super.initState();
  }

  @override
  void didUpdateWidget(LockWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _showLock = true;
      _hideLockTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showLock
        ? Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.lock_outline,
                    size: 24.0,
                  ),
                ),
                onTap: () {
                  BlocProvider.of<UiBloc>(context).add(UiEvents.showAll);
                  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
                },
              ),
            ),
        )
        : SizedBox.shrink();
  }

  _hideLockTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      _timer = Timer(Duration(seconds: 2), _hideLock);
    } else {
      _timer = Timer(Duration(seconds: 2), _hideLock);
    }
  }

  _hideLock() {
    setState(() {
      _showLock = false;
    });
  }
}
