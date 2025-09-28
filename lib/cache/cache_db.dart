import 'dart:async';

import 'package:ai_scribe_copilot/cache/dao/chunk_dao.dart';
import 'package:ai_scribe_copilot/cache/entity/audio_chunk_cache.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'cache_db.g.dart';

@Database(version: 1, entities: [AudioChunkCache])
abstract class CacheDatabase extends FloorDatabase {
  AudioChunkDao get chunkDao;
}

CacheDatabase? _instance;

Future<CacheDatabase> getDb() async {
  _instance ??= await $FloorCacheDatabase.databaseBuilder("app.db").build();
  return _instance!;
}
