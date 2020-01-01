import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:videos_sharing/player/bloc/state/controller.dart';

enum ControllerEvents { play, pause }

class ControllerBloc extends Bloc<ControllerEvents, PlayerControllerState> {
  VideoPlayerController _controller;
  final String videoPath;
  ControllerBloc(this.videoPath);
  @override
  PlayerControllerState get initialState => initializePlayer();

  @override
  Stream<PlayerControllerState> mapEventToState(ControllerEvents event) async* {
    switch (event) {
      case ControllerEvents.play:
        _controller.play();
        break;
      case ControllerEvents.pause:
        _controller.pause();
        break;
      default:
        throw "unhandled exception $event";
    }
  }

  PlayerControllerState initializePlayer() {
    _controller = VideoPlayerController.network(videoPath);
    return PlayerControllerState(_controller);
  }

  @override
  Future<void> close() {
    _controller.dispose();
    return super.close();
  }
}
