import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:videos_sharing/player/bloc/state/ui.dart';

enum UiEvents {
  showAll,
  hideAll,
  showTop,
  showCenter,
  showRotation,
  showBottom
}

class UiBloc extends Bloc<UiEvents, UiState> {
  bool _autoHide = true;

  @override
  UiState get initialState => _initValue();
  Timer _timerAll;
  @override
  Stream<UiState> mapEventToState(UiEvents event) async* {
    switch (event) {
      case UiEvents.showTop:
        yield UiState(false, false, false, true);
        break;
      case UiEvents.showCenter:
        yield UiState(false, true, false, false);
        break;
      case UiEvents.showRotation:
        yield UiState(false, false, true, false);
        break;
      case UiEvents.showBottom:
        _hideStatusBar();
        yield UiState(true, false, false, false);
        break;
      case UiEvents.showAll:
        hideShowAllTimer();
        _showStatusBar();
        yield UiState(true, true, true, true);
        break;
      case UiEvents.hideAll:
        _hideStatusBar();
        yield UiState(false, false, false, false);
        break;
    }
  }

  hideShowAllTimer({bool addTime = false, bool autoHide}) {
    if (autoHide != null) {
      _autoHide = autoHide;
    }
    if (_timerAll != null && _timerAll.isActive) {
      _timerAll.cancel();
      if (addTime) {
        _addTime();
      } else {
        _hideAll();
      }
    } else if (state.showCenter && !addTime) {
      this.add(UiEvents.hideAll);
    } else {
      _addTime();
    }
  }

  _addTime() {
    if (_autoHide) {
      _timerAll = Timer(Duration(seconds: 2), () {
        _hideAll();
      });
    }
  }

  _hideAll() {
    if (_autoHide) {
      this.add(UiEvents.hideAll);
    }
  }

  _showStatusBar() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  _hideStatusBar() {
    Future.delayed(Duration(milliseconds: 500), () {
      SystemChrome.setEnabledSystemUIOverlays([]);
    });
  }

  UiState _initValue() {
    _hideStatusBar();
    return UiState(false, false, false, false);
  }
}
