import 'package:flutter/material.dart';

class PlayerControllerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlayerControllerWidgetState();
  }
}

class _PlayerControllerWidgetState extends State<PlayerControllerWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  bool _isPlaying = true;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      width: mediaQuery.orientation == Orientation.portrait
          ? mediaQuery.size.width
          : mediaQuery.size.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            Icons.skip_previous,
            size: 36.0,
            color: Colors.grey[600],
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedIcon(
                icon: AnimatedIcons.pause_play,
                size: 56.0,
                color: Colors.white,
                progress: _animationController,
              ),
            ),
            onTap: () {
              _isPlaying
                  ? _animationController.forward()
                  : _animationController.reverse();
              _isPlaying = !_isPlaying;
            },
          ),
          Icon(
            Icons.skip_next,
            size: 36.0,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }
}
