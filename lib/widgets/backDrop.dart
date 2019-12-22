//import 'package:flutter/material.dart';
//import 'package:meta/meta.dart';
//import 'package:videos_sharing/widgets/front_layer.dart';
//
//const double _kFlingVelocity = 2.0;
//const Color _kFlutterBlue = Color(0xFF003D75);
//
//class Backdrop extends StatefulWidget {
//  final Widget frontLayer;
//  final Widget backLayer;
//  final Widget frontTitle;
//  final Widget backTitle;
//
//  const Backdrop({
//    @required this.frontLayer,
//    @required this.backLayer,
//    @required this.frontTitle,
//    @required this.backTitle,
//  })  : assert(frontLayer != null),
//        assert(backLayer != null),
//        assert(frontTitle != null),
//        assert(backTitle != null);
//
//  @override
//  _BackdropState createState() => _BackdropState();
//}
//
//class _BackdropState extends State<Backdrop>
//    with SingleTickerProviderStateMixin {
//  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
//
//  AnimationController _controller;
//
//  @override
//  void initState() {
//    super.initState();
//    _controller = AnimationController(
//      duration: Duration(milliseconds: 300),
//      value: 1.0,
//      vsync: this,
//    );
//  }
//
//  @override
//  void dispose() {
//    _controller.dispose();
//    super.dispose();
//  }
//
//  bool get _frontLayerVisible {
//    final AnimationStatus status = _controller.status;
//    return status == AnimationStatus.completed ||
//        status == AnimationStatus.forward;
//  }
//
//  void _toggleBackdropLayerVisibility() {
//    _controller.fling(
//        velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
//  }
//
//  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
//    double layerTitleHeight = 230.0;
//    final Size layerSize = constraints.biggest;
//    final double layerTop = layerSize.height - layerTitleHeight;
//
//    Animation<RelativeRect> layerAnimation = RelativeRectTween(
//      begin: RelativeRect.fromLTRB(
//          0.0, layerTop, 0.0, layerTop - layerSize.height),
//      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
//    ).animate(_controller.view);
//    return Stack(
//      key: _backdropKey,
//      children: <Widget>[
//        ExcludeSemantics(
//          child: widget.backLayer,
//          excluding: _frontLayerVisible,
//        ),
//        PositionedTransition(
//          rect: layerAnimation,
//          child: FrontLayerWidget(
//            onTap: _toggleBackdropLayerVisibility,
//            child: widget.frontLayer,
//          ),
//        ),
//      ],
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final ThemeData theme = Theme.of(context);
//    final bool isDark = theme.brightness == Brightness.dark;
//
//    var appBar = AppBar(
//      elevation: 0.0,
//      backgroundColor: isDark ? _kFlutterBlue : theme.primaryColor,
//      title: Text('Foto Face'),
//      actions: <Widget>[
//        IconButton(
//          icon: AnimatedIcon(
//            semanticLabel: 'menu',
//            icon: AnimatedIcons.close_menu,
//            progress: _controller,
//          ),
//          onPressed: _toggleBackdropLayerVisibility,
//        ),
//      ],
//    );
//    return Scaffold(
//      backgroundColor: isDark ? _kFlutterBlue : theme.primaryColor,
//      appBar: appBar,
//      body: LayoutBuilder(builder: _buildStack),
//    );
//  }
//}