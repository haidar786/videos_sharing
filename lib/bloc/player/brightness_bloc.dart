import 'package:bloc/bloc.dart';
import 'package:screen/screen.dart';

class BrightnessBloc extends Bloc<double, double> {
  @override
  double get initialState => _getInitBrightness();

  @override
  Stream<double> mapEventToState(double event) async* {
    Screen.setBrightness(event);
    yield event;
  }

  double _getInitBrightness() {
    _initBrightness();
    return 1.0;
  }

  void _initBrightness() async {
    double _brightness = await Screen.brightness;
    print("init brightness -> "+_brightness.toString());
    this.add(_brightness);
  }
}
