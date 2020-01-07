import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videos_sharing/player/bloc/ui_bloc.dart';
import 'package:videos_sharing/player/bloc/state/ui.dart';

class TopBarWidget extends StatelessWidget {
  TopBarWidget({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UiBloc, UiState>(
      builder: (BuildContext context, UiState uiState) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: uiState.showTop
              ? Column(
                  children: <Widget>[
                    AppBar(
                      backgroundColor: Colors.transparent.withOpacity(0.3),
                      title: Text(title),
                      elevation: 0.0,
                      actions: <Widget>[
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.closed_caption),
                          ),
                          onTap: () {},
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.more_vert),
                          ),
                          onTap: () {},
                        ),
                      ],
                    )
                  ],
                )
              : SizedBox.shrink(),
        );
      },
    );
  }
}
