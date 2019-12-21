import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/bloc/player/aspect_ratio_bloc.dart';
import 'package:videos_sharing/bloc/state/aspect_ratio.dart';

class AspectRatioNameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AspectRatioBloc, AspectRatioState>(
      builder: (BuildContext context, AspectRatioState state) {
        return Visibility(
          visible: true,
          child: Text(
            state.aspectRatioName,
            style: TextStyle(color: Colors.white, fontSize: 40.0),
          ),
        );
      },
    );
  }
}
