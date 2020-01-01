import 'package:bloc/bloc.dart';
import 'package:videos_sharing/player/bloc/state/volume.dart';
import 'package:volume_watcher/volume_watcher.dart';

class VolumeBloc extends Bloc<VolumeControllerState, VolumeControllerState> {
  @override
  VolumeControllerState get initialState => _getInitVolume();

  @override
  Stream<VolumeControllerState> mapEventToState(
      VolumeControllerState event) async* {
    VolumeWatcher.setVolume(event.currentVolume);
    yield event;
  }

  VolumeControllerState _getInitVolume() {
    _initVolumeState();
    return VolumeControllerState(8, 15,false);
  }

  _initVolumeState() async {
    num currentVolume = await VolumeWatcher.getCurrentVolume;
    num maxVolume = await VolumeWatcher.getMaxVolume;
    this.add(
      VolumeControllerState(
        currentVolume.toDouble(),
        maxVolume.toDouble(),
        false
      ),
    );
  }
}
