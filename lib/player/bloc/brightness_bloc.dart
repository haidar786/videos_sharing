import 'package:bloc/bloc.dart';
import 'package:screen/screen.dart';
import 'package:videos_sharing/player/bloc/state/brightness.dart';

class BrightnessBloc
    extends Bloc<BrightnessControllerState, BrightnessControllerState> {
  @override
  BrightnessControllerState get initialState => _getInitBrightness();

  @override
  Stream<BrightnessControllerState> mapEventToState(
      BrightnessControllerState brightnessControllerState) async* {
    Screen.setBrightness(
        brightnessControllerState.currentBrightness.clamp(0.1, 1.0));
    yield BrightnessControllerState(brightnessControllerState.currentBrightness,
        brightnessControllerState.shouldVisible);
  }

  BrightnessControllerState _getInitBrightness() {
    _initBrightness();
    return BrightnessControllerState(1.0, false);
  }

  void _initBrightness() async {
    double _brightness = await Screen.brightness;
    this.add(BrightnessControllerState(_brightness, false));
  }
}
