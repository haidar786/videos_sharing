import 'package:bloc/bloc.dart';
import 'package:videos_sharing/player/bloc/state/ui.dart';

enum UiEvents { showAll, showTop, showCenter, showRotation, showBottom }

class UiBloc extends Bloc<UiEvents, UiState> {
  @override
  UiState get initialState => UiState(false, false, false, false);

  @override
  Stream<UiState> mapEventToState(UiEvents event) async* {
    switch (event) {
      case UiEvents.showTop:
        yield UiState(false, false, false, true);
        break;
      case UiEvents.showCenter:
        yield UiState(false, true, false, false);
        break;
      case UiEvents.showRotation:
        yield UiState(false, false, true, false);
        break;
      case UiEvents.showBottom:
        yield UiState(true, false, false, false);
        break;
      case UiEvents.showAll:
        yield UiState(true, true, true, true);
        break;
    }
  }
}
