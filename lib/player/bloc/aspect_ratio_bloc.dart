import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:videos_sharing/player/bloc/state/aspect_ratio.dart';

enum AspectRatioEvents { original, fourByThree, sixteenByNine }

class AspectRatioBloc extends Bloc<AspectRatioState, AspectRatioState> {
  @override
  AspectRatioState get initialState => AspectRatioState(
      0.0, Icons.aspect_ratio, "Original", AspectRatioEvents.original, false);

  @override
  Stream<AspectRatioState> mapEventToState(
      AspectRatioState aspectRatioState) async* {
    yield aspectRatioState;
  }
}
