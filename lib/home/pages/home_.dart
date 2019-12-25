import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:videos_sharing/home/constants.dart';
import 'package:videos_sharing/home/pages/category.dart';
import 'package:videos_sharing/home/pages/home.dart';
import 'package:videos_sharing/home/widgets/backdrop/backdrop.dart';
import 'package:videos_sharing/home/widgets/category/app_category.dart';

class GalleryHome extends StatefulWidget {
  const GalleryHome({
    Key key,
    this.testMode = false,
    this.optionsPage,
  }) : super(key: key);

  final Widget optionsPage;
  final bool testMode;

  // In checked mode our MaterialApp will show the default "debug" banner.
  // Otherwise show the "preview" banner.
  static bool showPreviewBanner = true;

  @override
  _GalleryHomeState createState() => _GalleryHomeState();
}

class _GalleryHomeState extends State<GalleryHome>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  AnimationController _controller;
  AppCategory _category;

  static Widget _topHomeLayout(
      Widget currentChild, List<Widget> previousChildren) {
    return Stack(
      children: <Widget>[
        ...previousChildren,
        if (currentChild != null) currentChild,
      ],
      alignment: Alignment.topCenter,
    );
  }

  static const AnimatedSwitcherLayoutBuilder _centerHomeLayout =
      AnimatedSwitcher.defaultLayoutBuilder;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      debugLabel: 'preview banner',
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final MediaQueryData media = MediaQuery.of(context);
    final bool centerHome =
        media.orientation == Orientation.portrait && media.size.height < 800.0;

    const Curve switchOutCurve =
        Interval(0.4, 1.0, curve: Curves.fastOutSlowIn);
    const Curve switchInCurve = Interval(0.4, 1.0, curve: Curves.fastOutSlowIn);

    Widget home = Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? kFlutterBlue : theme.primaryColor,
      body: SafeArea(
        bottom: false,
        child: WillPopScope(
          onWillPop: () {
            // Pop the category page if Android back button is pressed.
            if (_category != null) {
              setState(() => _category = null);
              return Future<bool>.value(false);
            }
            return Future<bool>.value(true);
          },
          child: Backdrop(
            backTitle: const Text('Options'),
            backLayer: widget.optionsPage,
            frontAction: AnimatedSwitcher(
              duration: kFrontLayerSwitchDuration,
              switchOutCurve: switchOutCurve,
              switchInCurve: switchInCurve,
              child: _category == null
                  ? const Icon(Icons.looks) //_FlutterLogo()
                  : IconButton(
                      icon: const BackButtonIcon(),
                      tooltip: 'Back',
                      onPressed: () => setState(() => _category = null),
                    ),
            ),
            frontTitle: AnimatedSwitcher(
              duration: kFrontLayerSwitchDuration,
              child: _category == null
                  ? const Text('Flutter gallery')
                  : Text(_category.name),
            ),
            frontHeading: widget.testMode ? null : Container(height: 24.0),
            frontLayer: AnimatedSwitcher(
              duration: kFrontLayerSwitchDuration,
              switchOutCurve: switchOutCurve,
              switchInCurve: switchInCurve,
              layoutBuilder: centerHome ? _centerHomeLayout : _topHomeLayout,
              child: _category != null
                  ? VideoFolderPage(
                      sharedPreferences: null,
                      onThemeChange: null,
                      dataString: null,
                      baseDatabase: null) //_DemosPage(_category)
                  : CategoriesPage(
                      categories: kAllGalleryDemoCategories,
                      onCategoryTap: (AppCategory category) {
                        setState(() => _category = category);
                      },
                    ),
            ),
          ),
        ),
      ),
    );

    assert(() {
      GalleryHome.showPreviewBanner = false;
      return true;
    }());

    if (GalleryHome.showPreviewBanner) {
      home = Stack(
        fit: StackFit.expand,
        children: <Widget>[
          home,
          FadeTransition(
            opacity:
                CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            child: const Banner(
              message: 'PREVIEW',
              location: BannerLocation.topEnd,
            ),
          ),
        ],
      );
    }
    home = AnnotatedRegion<SystemUiOverlayStyle>(
      child: home,
      value: SystemUiOverlayStyle.light,
    );

    return home;
  }
}
