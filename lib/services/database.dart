import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:videos_sharing/model/link.dart';

abstract class BaseDatabase {
  //link db
  Future<Database> openTheDatabase();
  Future<void> insertLink(Link link);
  Future<void> deleteLink(int id);
  Future<Database> getInstance();
}

class TorrentStreamerDatabase implements BaseDatabase {
  Future<Database> _database;
  //Link database
  Future<Database> openTheDatabase() async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'link_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE links(id INT PRIMARY KEY, link STRING)",
        );
      },
      version: 1,
    );
    return _database;
  }

  Future<void> insertLink(Link link) async {
    final Database db =
        _database != null ? await _database : await openTheDatabase();

    await db.insert(
      'links',
      link.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> deleteLink(int id) async {
    final Database db =
        _database != null ? await _database : await openTheDatabase();

    db.delete(
      'links',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<Database> getInstance() async {
    final Database db =
        _database != null ? await _database : await openTheDatabase();
    return db;
  }
}
