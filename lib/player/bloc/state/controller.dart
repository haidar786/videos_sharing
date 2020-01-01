import 'package:video_player/video_player.dart';

class PlayerControllerState {
  VideoPlayerController controller;
  bool showBottom;
  bool showCenter;
  bool showRotation;
  bool showTop;

  PlayerControllerState(this.controller, this.showBottom,
      this.showCenter, this.showRotation, this.showTop);
}
