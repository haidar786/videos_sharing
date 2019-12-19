import 'package:bloc/bloc.dart';

enum AspectRatioEvents { original, stretch }

class AspectRatioBloc extends Bloc<AspectRatioEvents, double> {
  @override
  double get initialState => 1.0;

  @override
  Stream<double> mapEventToState(AspectRatioEvents event) async* {
    switch (event) {
      case AspectRatioEvents.original:
        yield 1.0;
        break;
      case AspectRatioEvents.stretch:
        yield 2.0;
        break;
      default:
        throw Exception('unhandled event: $event');
    }
  }
}
