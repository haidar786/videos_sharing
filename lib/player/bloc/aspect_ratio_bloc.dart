import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:videos_sharing/player/bloc/state/aspect_ratio.dart';

enum AspectRatioEvents { original, twoBYOne, fourByThree, sixteenByNine }

class AspectRatioBloc extends Bloc<AspectRatioEvents, AspectRatioState> {
  @override
  AspectRatioState get initialState => AspectRatioState(
      0.0, Icons.aspect_ratio, "Original", AspectRatioEvents.original);

  @override
  Stream<AspectRatioState> mapEventToState(AspectRatioEvents event) async* {
    switch (event) {
      case AspectRatioEvents.original:
        yield AspectRatioState(0.0, Icons.aspect_ratio, "Original", event);
        break;
      case AspectRatioEvents.twoBYOne:
        yield AspectRatioState(2 / 1, Icons.crop_3_2, "2:1", event);
        break;
      case AspectRatioEvents.fourByThree:
        yield AspectRatioState(4 / 3, Icons.crop_5_4, "4:3", event);
        break;
      case AspectRatioEvents.sixteenByNine:
        yield AspectRatioState(16 / 9, Icons.crop_5_4, "16:9", event);
        break;
      default:
        throw Exception('unhandled event: $event');
    }
  }
}
