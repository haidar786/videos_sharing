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
  bool _isPlaying = true;

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
        _showStatusBar();
        hideShowAllTimer();
        yield UiState(true, true, true, true);
        break;
      case UiEvents.hideAll:
        yield UiState(false, false, false, false);
        break;
    }
  }



  hideShowAllTimer({bool addTime = false, bool isPlaying}) {
    if (isPlaying != null){
      _isPlaying = isPlaying;
    }
    if (_timerAll != null && _timerAll.isActive) {
      _timerAll.cancel();
      if (addTime) {
        _addTime(_isPlaying);
      } else {
        _hideAll(_isPlaying);
      }
    } else if (state.showCenter && !addTime) {
      this.add(UiEvents.hideAll);
    } else {
      _addTime(_isPlaying);
    }
  }

  _addTime(bool isPlaying) {
    _timerAll = Timer(Duration(seconds: 3), (){
      _hideAll(isPlaying);
    });
  }

  _hideAll(bool isPlaying) {
    if(isPlaying){
      this.add(UiEvents.hideAll);
      _hideStatusBar();
    }

  }

  _showStatusBar() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  _hideStatusBar() {
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

//  hideShowOverlay({bool isPlaying = true}) {
//    if (_timerAll != null && _timerAll.isActive) {
//      _timerAll.cancel();
//      SystemChrome.setEnabledSystemUIOverlays([]);
//      this.add(UiEvents.hideAll);
//    } else if (state.showCenter) {
//      SystemChrome.setEnabledSystemUIOverlays([]);
//      this.add(UiEvents.hideAll);
//    } else {
//      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
//      this.add(UiEvents.showAll);
//      _timerAll = Timer(Duration(seconds: 3), (){
//        if (isPlaying) {
//          this.add(UiEvents.hideAll);
//          SystemChrome.setEnabledSystemUIOverlays([]);
//        }
//      });
//    }
//  }
}
