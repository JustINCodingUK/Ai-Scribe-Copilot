import 'package:ai_scribe_copilot/cache/entity/audio_chunk_cache.dart';
import 'package:floor/floor.dart';

@dao
abstract class AudioChunkDao {

  @Query("SELECT * FROM AudioChunkCache")
  Stream<AudioChunkCache?> getAllChunks();
  
  @Query("SELECT MAX(chunkNumber) FROM AudioChunkCache")
  Future<int?> getLatestChunkNumber();

  @Query("DELETE WHERE id=:id")
  Future<void> deleteById(int id);

  @insert
  Future<void> insertCache(AudioChunkCache cache);

}