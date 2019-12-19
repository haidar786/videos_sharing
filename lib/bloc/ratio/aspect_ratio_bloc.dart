import 'package:bloc/bloc.dart';
import 'package:videos_sharing/model/aspect_ratio_model.dart';
import 'package:flutter/material.dart';

enum AspectRatioEvents { original, twoBYOne, fourByThree, sixteenByNine }

class AspectRatioBloc extends Bloc<AspectRatioEvents, AspectRatioModel> {
  @override
  AspectRatioModel get initialState => AspectRatioModel(
      0.0, Icons.aspect_ratio, "Original", AspectRatioEvents.original);

  @override
  Stream<AspectRatioModel> mapEventToState(AspectRatioEvents event) async* {
    switch (event) {
      case AspectRatioEvents.original:
        yield AspectRatioModel(0.0, Icons.aspect_ratio, "Original", event);
        break;
      case AspectRatioEvents.twoBYOne:
        yield AspectRatioModel(2 / 1, Icons.crop_3_2, "2:1", event);
        break;
      case AspectRatioEvents.fourByThree:
        yield AspectRatioModel(4 / 3, Icons.crop_5_4, "4:3", event);
        break;
      case AspectRatioEvents.sixteenByNine:
        yield AspectRatioModel(16 / 9, Icons.crop_5_4, "16:9", event);
        break;
      default:
        throw Exception('unhandled event: $event');
    }
  }
}
