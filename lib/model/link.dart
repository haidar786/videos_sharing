import 'package:flutter/material.dart';

class Link {
  final int id;
  final String link;

  Link({
    @required this.id,
    @required this.link,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'link': link,
    };
  }
}
