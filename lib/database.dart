// database.dart

// required package imports
import 'dart:async';
import 'package:flat_orm/flat_orm.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'entity/record.dart';
import 'entity/chapter.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 2, entities: [Record, Chapter])
abstract class AppDatabase extends FlatDatabase {
  RecordDao get recordDao;
  ChapterDao get chapterDao;
}