import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_json_widget/flutter_json_widget.dart';

class TestStuffs extends StatefulWidget {
  TestStuffs({Key key, @required this.jsonIntent}) : super(key: key);
  final jsonIntent;
  @override
  State<StatefulWidget> createState() {
    return _TestStuffsState();
  }
}

class _TestStuffsState extends State<TestStuffs> {
  @override
  Widget build(BuildContext context) {
    var testString = '''{
        "I": "How are you?",
        "You": "Excellent!"}
        ''';
    Map<String, dynamic> jsonObj = jsonDecode(widget.jsonIntent);

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: JsonViewerWidget(jsonObj),
      )),
    );
  }
}
