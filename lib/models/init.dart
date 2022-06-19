
import 'dart:io';

import 'package:flutter_bookkeeper/models/tag.dart';
import 'package:sqflite/sqflite.dart';

const dbName = "bookkeeper.db";

Future<Database?> initDataBase() async {
  var databasesPath = await getDatabasesPath();
  var path = databasesPath + "/" + dbName;
  try {
    await Directory(databasesPath).create(recursive: true);
  } catch (_) {
    return null;
  }

  _onCreate(Database db) async {
    TagDao(db).init();
  }

  var db = await openDatabase(path, onConfigure: _onCreate);
  return db;
}