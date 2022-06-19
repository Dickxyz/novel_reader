import 'package:flutter_bookkeeper/models/tag.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tuple/tuple.dart';

import 'models/init.dart';

late TagDao _tagDao;

Future<void> initProvider() async {
  Database? db = await initDataBase();
  _tagDao = TagDao(db!);
}

final tagsProvider = FutureProvider<List<Tag>>((ref) async {
  return await _tagDao.getAllTag();
});
