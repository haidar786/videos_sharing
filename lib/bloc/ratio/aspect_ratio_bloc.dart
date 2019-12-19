import 'package:bloc/bloc.dart';
import 'package:videos_sharing/model/aspect_ratio_model.dart';
import 'package:flutter/material.dart';

enum AspectRatioEvents { original, stretch, twoBYOne }

class AspectRatioBloc extends Bloc<AspectRatioEvents, AspectRatioModel> {
  @override
  AspectRatioModel get initialState =>
      AspectRatioModel(0.0, Icons.drive_eta, "Original");

  @override
  Stream<AspectRatioModel> mapEventToState(AspectRatioEvents event) async* {
    switch (event) {
      case AspectRatioEvents.original:
        yield AspectRatioModel(0.0, Icons.crop_original, "Original");
        break;
      case AspectRatioEvents.stretch:
        yield AspectRatioModel(10.0, Icons.aspect_ratio, "10.0");
        break;
      case AspectRatioEvents.twoBYOne:
        yield AspectRatioModel(2.0, Icons.crop_3_2, "2.0");
        break;
      default:
        throw Exception('unhandled event: $event');
    }
  }
}
