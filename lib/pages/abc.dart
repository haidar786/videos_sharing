
import 'package:flutter/material.dart';
class TestStuffs extends StatefulWidget {
  TestStuffs({Key key,@required this.dataString}) : super(key: key);
  final dataString;
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
   // Map<String, dynamic> jsonObj = jsonDecode(widget.dataString);

    return Scaffold(
      body: Center(child: Text(widget.dataString != null ? widget.dataString : "Null stuffs"),)
    );
  }
}
