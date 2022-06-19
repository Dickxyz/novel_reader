import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novel_reader/database.dart';
import 'package:novel_reader/requests.dart';
import 'package:tuple/tuple.dart';

import 'entity/record.dart';

final dataBaseProvider = FutureProvider<AppDatabase>((ref) async {
  return await $FlatAppDatabase.databaseBuilder('app_database.db').build();
});

final myEbokksProvider = FutureProvider<List<NovelInfo>>((ref) async {
  return await getNovelListApi();
});

final chaptersProvider = FutureProvider.family<List<ChapterInfo>, int> ((ref, arg) async {
  return await getChapterInfoListApi(arg);
});

final chapterContentProvider =  FutureProvider.family<ChapterInfo, Tuple2<int, int>> ((ref, args) async {
  final res = await getChapterDetailListApi(args.item1, [args.item2]);
  return res.first;
});

final recordProvider = FutureProvider.family<Record?, int> ((ref, arg) async {
  final db = await ref.watch(dataBaseProvider.future);
  return await db.recordDao.findRecordById(arg);
});

final contentProvider = FutureProvider.family<ChapterInfo, int> ((ref, arg) async {
  final record = await ref.watch(recordProvider(arg).future);
  final lastChapter = await ref.watch(chapterContentProvider(Tuple2(arg, record!.currentChapterId + 1)).future);
  return lastChapter;
});
