import 'package:flat_orm/flat_orm.dart';

@Entity(tableName: "chapters", primaryKeys: ["novelId", "chapterId"])
class Chapter {
  final int novelId, chapterId;
  final String name;
  final String? content;

  Chapter(this.novelId, this.chapterId, this.name, this.content);
}


@dao
abstract class ChapterDao {
  @Query('SELECT * FROM records WHERE novelId = :novelId')
  Future<List<Chapter>> findAllChapters(int novelId);

  @Query('SELECT * FROM records WHERE novelId = :novelId AND chapterId = :chapterId')
  Future<Chapter?> findRecordById(int novelId, int chapterId);

  @update
  Future<void> updateChapter(Chapter chapter);

  @insert
  Future<void> insertChapter(Chapter chapter);
}
