import 'package:flutter/material.dart';
import 'package:videos_sharing/bloc/ratio/aspect_ratio_bloc.dart';
class TopBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.lock_outline),
              ),
              onTap: () {},
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.subtitles),
              ),
              onTap: () {},
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.aspect_ratio),
              ),
              onTap: () {
                aspectRatioBloc.updateAspectRatio(2.0);
              },
            ),
          ],
        )
      ],
    );
  }
}
