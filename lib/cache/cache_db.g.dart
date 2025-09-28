// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_db.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $CacheDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $CacheDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $CacheDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<CacheDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorCacheDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $CacheDatabaseBuilderContract databaseBuilder(String name) =>
      _$CacheDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $CacheDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$CacheDatabaseBuilder(null);
}

class _$CacheDatabaseBuilder implements $CacheDatabaseBuilderContract {
  _$CacheDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $CacheDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $CacheDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<CacheDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$CacheDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$CacheDatabase extends CacheDatabase {
  _$CacheDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AudioChunkDao? _chunkDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
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
            'CREATE TABLE IF NOT EXISTS `AudioChunkCache` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `sessionId` TEXT NOT NULL, `chunkNumber` INTEGER NOT NULL, `filePath` TEXT NOT NULL, `isLast` INTEGER NOT NULL, `url` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AudioChunkDao get chunkDao {
    return _chunkDaoInstance ??= _$AudioChunkDao(database, changeListener);
  }
}

class _$AudioChunkDao extends AudioChunkDao {
  _$AudioChunkDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _audioChunkCacheInsertionAdapter = InsertionAdapter(
            database,
            'AudioChunkCache',
            (AudioChunkCache item) => <String, Object?>{
                  'id': item.id,
                  'sessionId': item.sessionId,
                  'chunkNumber': item.chunkNumber,
                  'filePath': item.filePath,
                  'isLast': item.isLast ? 1 : 0,
                  'url': item.url
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AudioChunkCache> _audioChunkCacheInsertionAdapter;

  @override
  Stream<AudioChunkCache?> getAllChunks() {
    return _queryAdapter.queryStream('SELECT * FROM AudioChunkCache',
        mapper: (Map<String, Object?> row) => AudioChunkCache(
            sessionId: row['sessionId'] as String,
            chunkNumber: row['chunkNumber'] as int,
            filePath: row['filePath'] as String,
            url: row['url'] as String,
            isLast: (row['isLast'] as int) != 0),
        queryableName: 'AudioChunkCache',
        isView: false);
  }

  @override
  Future<int?> getLatestChunkNumber() async {
    return _queryAdapter.query('SELECT MAX(chunkNumber) FROM AudioChunkCache',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> deleteById(int id) async {
    await _queryAdapter.queryNoReturn('DELETE WHERE id=?1', arguments: [id]);
  }

  @override
  Future<void> insertCache(AudioChunkCache cache) async {
    await _audioChunkCacheInsertionAdapter.insert(
        cache, OnConflictStrategy.abort);
  }
}
