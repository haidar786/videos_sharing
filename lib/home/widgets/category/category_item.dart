import 'package:flutter/material.dart';
import 'package:videos_sharing/home/widgets/category/app_category.dart';
import 'package:videos_sharing/home/constants.dart';

class AppCategoryItem extends StatelessWidget {
  const AppCategoryItem({
    Key key,
    this.category,
    this.onTap,
  }) : super(key: key);

  final AppCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    // This repaint boundary prevents the entire _CategoriesPage from being
    // repainted when the button's ink splash animates.
    return RepaintBoundary(
      child: RawMaterialButton(
        padding: EdgeInsets.zero,
        hoverColor: theme.primaryColor.withOpacity(0.05),
        splashColor: theme.primaryColor.withOpacity(0.12),
        highlightColor: Colors.transparent,
        onPressed: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                category.icon,
                size: 60.0,
                color: isDark ? Colors.white : kFlutterBlue,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              height: 48.0,
              alignment: Alignment.center,
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                style: theme.textTheme.subhead.copyWith(
                  fontFamily: 'GoogleSans',
                  color: isDark ? Colors.white : kFlutterBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
