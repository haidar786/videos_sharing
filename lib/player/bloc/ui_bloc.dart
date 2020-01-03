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
  @override
  UiState get initialState => UiState(false, false, false, false);
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
        yield UiState(true, false, false, false);
        break;
      case UiEvents.showAll:
        yield UiState(true, true, true, true);
       // _showStatusBar();
        _hideAllTimer();
        break;
      case UiEvents.hideAll:
        yield UiState(false, false, false, false);
        break;
    }
  }

  _hideAllTimer() {
    if (_timerAll != null && _timerAll.isActive) {
      _timerAll.cancel();
      _hideAll();
    } else {
      _timerAll = Timer(Duration(seconds: 3), _hideAll);
    }
  }

  _hideAll() {
    this.add(UiEvents.hideAll);
    _hideStatusBar();
  }

  _showStatusBar() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }
  _hideStatusBar() {
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
}
