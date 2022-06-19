// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FlatGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FlatAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  RecordDao? _recordDaoInstance;

  ChapterDao? _chapterDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `records` (`id` INTEGER NOT NULL, `currentChapterId` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `chapters` (`novelId` INTEGER NOT NULL, `chapterId` INTEGER NOT NULL, `name` TEXT NOT NULL, `content` TEXT, PRIMARY KEY (`novelId`, `chapterId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  Future<T> transaction<T>(Future<T> Function(dynamic) action) async {
    if (database is sqflite.Transaction) {
      return action(this);
    } else {
      final _changeListener = StreamController<String>.broadcast();
      final Set<String> _events = {};
      _changeListener.stream.listen(_events.add);
      final T result = await (database as sqflite.Database).transaction<T>(
          (transaction) =>
              action(_$AppDatabase(_changeListener)..database = transaction));
      await _changeListener.close();
      _events.forEach(changeListener.add);
      return result;
    }
  }

  @override
  RecordDao get recordDao {
    return _recordDaoInstance ??=
        _$RecordDao(database, changeListener, transaction);
  }

  @override
  ChapterDao get chapterDao {
    return _chapterDaoInstance ??=
        _$ChapterDao(database, changeListener, transaction);
  }
}

class _$RecordDao extends RecordDao {
  _$RecordDao(this.database, this.changeListener, this.transaction)
      : _queryAdapter = QueryAdapter(database),
        _recordInsertionAdapter = InsertionAdapter(
            database,
            'records',
            (Record item) => <String, Object?>{
                  'id': item.id,
                  'currentChapterId': item.currentChapterId
                }),
        _recordUpdateAdapter = UpdateAdapter(
            database,
            'records',
            ['id'],
            (Record item) => <String, Object?>{
                  'id': item.id,
                  'currentChapterId': item.currentChapterId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final Future<T> Function<T>(Future<T> Function(dynamic)) transaction;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Record> _recordInsertionAdapter;

  final UpdateAdapter<Record> _recordUpdateAdapter;

  @override
  Future<List<Record>> findAllRecord() async {
    return _queryAdapter.queryList('SELECT * FROM records',
        mapper: (Map<String, Object?> row) =>
            Record(row['id'] as int, row['currentChapterId'] as int));
  }

  @override
  Future<Record?> findRecordById(int id) async {
    return _queryAdapter.query('SELECT * FROM records WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            Record(row['id'] as int, row['currentChapterId'] as int),
        arguments: [id]);
  }

  @override
  Future<void> insertNovel(Record novel) async {
    await _recordInsertionAdapter.insert(novel, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTask(Record novel) async {
    await _recordUpdateAdapter.update(novel, OnConflictStrategy.abort);
  }
}

class _$ChapterDao extends ChapterDao {
  _$ChapterDao(this.database, this.changeListener, this.transaction)
      : _queryAdapter = QueryAdapter(database),
        _chapterInsertionAdapter = InsertionAdapter(
            database,
            'chapters',
            (Chapter item) => <String, Object?>{
                  'novelId': item.novelId,
                  'chapterId': item.chapterId,
                  'name': item.name,
                  'content': item.content
                }),
        _chapterUpdateAdapter = UpdateAdapter(
            database,
            'chapters',
            ['novelId', 'chapterId'],
            (Chapter item) => <String, Object?>{
                  'novelId': item.novelId,
                  'chapterId': item.chapterId,
                  'name': item.name,
                  'content': item.content
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final Future<T> Function<T>(Future<T> Function(dynamic)) transaction;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Chapter> _chapterInsertionAdapter;

  final UpdateAdapter<Chapter> _chapterUpdateAdapter;

  @override
  Future<List<Chapter>> findAllChapters(int novelId) async {
    return _queryAdapter.queryList('SELECT * FROM records WHERE novelId = ?1',
        mapper: (Map<String, Object?> row) => Chapter(
            row['novelId'] as int,
            row['chapterId'] as int,
            row['name'] as String,
            row['content'] as String?),
        arguments: [novelId]);
  }

  @override
  Future<Chapter?> findRecordById(int novelId, int chapterId) async {
    return _queryAdapter.query(
        'SELECT * FROM records WHERE novelId = ?1 AND chapterId = ?2',
        mapper: (Map<String, Object?> row) => Chapter(
            row['novelId'] as int,
            row['chapterId'] as int,
            row['name'] as String,
            row['content'] as String?),
        arguments: [novelId, chapterId]);
  }

  @override
  Future<void> insertChapter(Chapter chapter) async {
    await _chapterInsertionAdapter.insert(chapter, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateChapter(Chapter chapter) async {
    await _chapterUpdateAdapter.update(chapter, OnConflictStrategy.abort);
  }
}
