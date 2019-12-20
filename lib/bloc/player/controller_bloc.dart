import 'package:bloc/bloc.dart';
import 'package:video_player/video_player.dart';

enum ControllerEvents { play, pause }

class ControllerBloc extends Bloc<ControllerEvents, VideoPlayerController> {
  VideoPlayerController _controller;
  final String videoPath;
  ControllerBloc(this.videoPath);

  @override
  VideoPlayerController get initialState => initializePlayer();

  @override
  Stream<VideoPlayerController> mapEventToState(ControllerEvents event) async* {
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

  VideoPlayerController initializePlayer() {
    _controller = VideoPlayerController.network(videoPath);
    _controller.initialize().then((_) {
      _controller.play();
    });
    return _controller;
  }

  @override
  Future<void> close() {
    _controller.dispose();
    return super.close();
  }
}
