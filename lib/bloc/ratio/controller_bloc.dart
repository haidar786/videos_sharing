import 'package:bloc/bloc.dart';
import 'package:video_player/video_player.dart';

enum ControllerEvents { play, pause }

class ControllerBloc extends Bloc<ControllerEvents, VideoPlayerController> {
  VideoPlayerController _controller;
  String _videoPath;

  ControllerBloc(String videoPath) {
    _videoPath = videoPath;
  }

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
    _controller = VideoPlayerController.network("https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4");
    _controller.initialize().then((_) {
      _controller.play();
    });
    return _controller;
  }
}
