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
      name: 'Media Player',
      icon: Icons.movie,
    ),
    AppCategory._(
      name: 'Audio Player',
      icon: Icons.audiotrack,
    ),
    AppCategory._(
      name: 'Radio',
      icon: Icons.radio,
    ),
    AppCategory._(
      name: 'Television',
      icon: Icons.tv,
    ),
    AppCategory._(
      name: 'Photos',
      icon: Icons.photo_library,
    ),
    AppCategory._(
      name: 'Wallpapers',
      icon: Icons.wallpaper,
    ),
    AppCategory._(
      name: 'Drawing',
      icon: Icons.palette,
    ),
    AppCategory._(
      name: 'Books',
      icon: Icons.book,
    ),
    AppCategory._(
      name: 'Chat',
      icon: Icons.chat,
    ),
    AppCategory._(
      name: 'Social',
      icon: Icons.group,
    ),
    AppCategory._(
      name: 'News',
      icon: Icons.chrome_reader_mode,
    ),
    AppCategory._(
      name: 'Notes',
      icon: Icons.event_note,
    ),
    AppCategory._(
      name: 'Watch',
      icon: Icons.watch,
    ),
    AppCategory._(
      name: 'Web',
      icon: Icons.web,
    ),
  ];
  return galleryDemos;
}

final List<AppCategory> kAllCategories = _buildCategories();

final Set<AppCategory> kAllGalleryDemoCategories =
    kAllCategories.map<AppCategory>((AppCategory category) => category).toSet();
