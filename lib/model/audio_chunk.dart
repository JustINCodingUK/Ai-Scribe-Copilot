import 'dart:typed_data';

class AudioChunk {
  final int number;
  final Float32List data;
  final bool isLast;

  AudioChunk({
    required this.number,
    required this.data,
    required this.isLast
  });
}