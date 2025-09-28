import 'dart:io';
import 'dart:typed_data';

import 'package:ai_scribe_copilot/cache/cache_db.dart';
import 'package:ai_scribe_copilot/cache/entity/audio_chunk_cache.dart';
import 'package:path_provider/path_provider.dart';

class CacheManager {
  final CacheDatabase db;

  const CacheManager(this.db);

  Future<void> saveChunk(
      {required String sessionId,
      required int chunkNumber,
      required String url,
      required bool isLast,
      required Float32List audioData}) async {
    final appDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDir.path}/$sessionId/$chunkNumber.wav";
    final file = await File(filePath).create(recursive: true);

    final byteBuffer = ByteData(audioData.length * 4);

    for (var i = 0; i < audioData.length; i++) {
      byteBuffer.setFloat32(i * 4, audioData[i], Endian.little);
    }
    await file.writeAsBytes(byteBuffer.buffer.asUint8List());

    final audioCache = AudioChunkCache(
      sessionId: sessionId,
      chunkNumber: chunkNumber,
      filePath: filePath,
      url: url,
      isLast: isLast,
    );

    await db.chunkDao.insertCache(audioCache);
  }

  Future<void> clearCacheById({required int id}) async {
    await db.chunkDao.deleteById(id);
  }

  Stream<AudioChunkCache?> getCache() {
    return db.chunkDao.getAllChunks();
  }

}
