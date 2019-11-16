import 'package:flutter/material.dart';

class Link {
  final String link;

  Link({
    @required this.link,
  });

  Map<String, dynamic> toMap() {
    return {
      'link': link,
    };
  }
}
