import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/bloc/ratio/aspect_ratio_bloc.dart';
import 'package:videos_sharing/model/aspect_ratio_model.dart';

class AspectRatioNameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AspectRatioBloc, AspectRatioModel>(
      builder: (BuildContext context, AspectRatioModel state) {
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
