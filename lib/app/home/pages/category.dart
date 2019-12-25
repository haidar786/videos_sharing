import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:videos_sharing/app/home/widgets/category/app_category.dart';
import 'package:videos_sharing/app/home/widgets/category/category_item.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({
    Key key,
    this.categories,
    this.onCategoryTap,
  }) : super(key: key);

  final Iterable<AppCategory> categories;
  final ValueChanged<AppCategory> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    const double aspectRatio = 160.0 / 180.0;
    final List<AppCategory> categoriesList = categories.toList();
    final int columnCount =
        (MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 3;

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      label: 'categories',
      explicitChildNodes: true,
      child: SingleChildScrollView(
        key: const PageStorageKey<String>('categories'),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double columnWidth =
                constraints.biggest.width / columnCount.toDouble();
            final double rowHeight = math.min(225.0, columnWidth * aspectRatio);
            final int rowCount =
                (categories.length + columnCount - 1) ~/ columnCount;

            // This repaint boundary prevents the inner contents of the front layer
            // from repainting when the backdrop toggle triggers a repaint on the
            // LayoutBuilder.
            return RepaintBoundary(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List<Widget>.generate(rowCount, (int rowIndex) {
                  final int columnCountForRow = rowIndex == rowCount - 1
                      ? categories.length -
                          columnCount * math.max<int>(0, rowCount - 1)
                      : columnCount;

                  return Row(
                    children: List<Widget>.generate(columnCountForRow,
                        (int columnIndex) {
                      final int index = rowIndex * columnCount + columnIndex;
                      final AppCategory category = categoriesList[index];

                      return SizedBox(
                        width: columnWidth,
                        height: rowHeight,
                        child: AppCategoryItem(
                          category: category,
                          onTap: () {
                            onCategoryTap(category);
                          },
                        ),
                      );
                    }),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}
