import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:videos_sharing/bloc/bloc.dart';

class AspectRatioBloc implements Bloc {
//  double _aspectRatio;
//
//  double get aspectRatio => _aspectRatio;

  final _aspectRatioController = PublishSubject<double>();

  Stream<double> get aspectRationStream => _aspectRatioController.stream;

  void updateAspectRatio(double aspectRatio) {
    // _aspectRatio = aspectRatio;
    _aspectRatioController.sink.add(aspectRatio);
  }

  @override
  void dispose() {
    _aspectRatioController.close();
  }
}

final aspectRatioBloc = AspectRatioBloc();
