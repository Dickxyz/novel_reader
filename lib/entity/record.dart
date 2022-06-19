import 'package:flat_orm/flat_orm.dart';

@Entity(tableName: "records")
class Record {
  @primaryKey
  final int id;

  final int currentChapterId;

  Record(this.id, this.currentChapterId);
}

@dao
abstract class RecordDao {
  @Query('SELECT * FROM records')
  Future<List<Record>> findAllRecord();

  @Query('SELECT * FROM records WHERE id = :id')
  Future<Record?> findRecordById(int id);

  @update
  Future<void> updateTask(Record novel);

  @insert
  Future<void> insertNovel(Record novel);
}
