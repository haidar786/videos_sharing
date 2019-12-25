import 'package:flutter/material.dart';

class AppCategory {
  const AppCategory._({
    @required this.name,
    @required this.icon,
  });

  final String name;
  final IconData icon;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    return other is AppCategory && other.name == name && other.icon == icon;
  }

  @override
  int get hashCode => hashValues(name, icon);

  @override
  String toString() {
    return '$runtimeType($name)';
  }
}

List<AppCategory> _buildCategories() {
  final List<AppCategory> galleryDemos = <AppCategory>[
    AppCategory._(
      name: 'File Manager',
      icon: Icons.insert_drive_file,
    ),
    AppCategory._(
      name: 'Media',
      icon: Icons.wb_iridescent,
    ),
    AppCategory._(
      name: 'Cupertino',
      icon: Icons.drive_eta,
    ),
    AppCategory._(
      name: 'Material',
      icon: Icons.card_giftcard,
    ),
    AppCategory._(
      name: 'Media Player',
      icon: Icons.videocam,
    ),
  ];
  return galleryDemos;
}

final List<AppCategory> kAllGalleryDemos = _buildCategories();
final Set<AppCategory> kAllGalleryDemoCategories = kAllGalleryDemos
    .map<AppCategory>((AppCategory category) => category)
    .toSet();
