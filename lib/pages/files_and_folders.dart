import 'package:flutter/material.dart';
import 'package:videos_sharing/model/files_and_folder.dart';

class FilesAndFoldersPage extends StatelessWidget {
  FilesAndFoldersPage({Key key, @required this.ffModel}) : super(key: key);
  final FFModel ffModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Files"),
        ),
        body: ListView(
          children: <Widget>[
            ListView(
              primary: false,
              shrinkWrap: true,
              children: ffModel.directories.map((element) {
                return ListTile(
                  leading: Icon(
                      Icons.folder,
                    ),
                  title: Text(element.path.split('/').last),
                  onTap: () {},
                );
              }).toList(),
            ),
            ListView(
              primary: false,
              shrinkWrap: true,
              children: ffModel.files.map((element) {
                return ListTile(
                  leading:
                    Icon(
                      Icons.insert_drive_file,
                    ),
                  title: Text(element.path.split('/').last),
                  onTap: () {},
                );
              }).toList(),
            ),
          ],
        ));
  }
}
