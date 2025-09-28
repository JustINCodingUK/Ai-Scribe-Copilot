import 'package:floor/floor.dart';

@entity
class AudioChunkCache {
  @PrimaryKey(autoGenerate: true)
  final int? id = null;

  final String sessionId;
  final int chunkNumber;
  final String filePath;
  final bool isLast;
  final String url;

  AudioChunkCache({
    required this.sessionId,
    required this.chunkNumber,
    required this.filePath,
    required this.url,
    required this.isLast
  });
}