import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:videos_sharing/player/bloc/state/aspect_ratio.dart';

enum AspectRatioEvents { original, fourByThree, sixteenByNine }

class AspectRatioBloc extends Bloc<AspectRatioState, AspectRatioState> {
  Timer _timer;
  @override
  AspectRatioState get initialState => AspectRatioState(
      0.0, Icons.aspect_ratio, "Original", AspectRatioEvents.original, false);

  @override
  Stream<AspectRatioState> mapEventToState(
      AspectRatioState aspectRatioState) async* {
    yield aspectRatioState;
    _hideATimer();
  }

  _hideATimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      _timer = Timer(Duration(seconds: 1), _hideA);
    } else {
      _timer = Timer(Duration(seconds: 1), _hideA);
    }
  }

  _hideA() {
    this.add(AspectRatioState(state.aspectRatio, state.icon,
        state.aspectRatioName, state.aspectRatioEvents, false));
  }
}
