import 'dart:developer';
import 'dart:ffi';
import 'dart:typed_data';



import 'package:flutter/services.dart';class MicrophoneController {

  final _chunkSize = 32000;
  final List<double> _chunkedBuffer = [];
  Stream<Float32List>? _audio;
  final _audioData = EventChannel(
    "io.github.justincodinguk.ai_scribe_copilot/MicStream",
  );
  final _micEvents = EventChannel(
    "io.github.justincodinguk.ai_scribe_copilot/MicEvents"
  );
  
  final _methodChannel = MethodChannel(
      "io.github.justincodinguk.ai_scribe_copilot/MicController");

  Stream<Float32List> get liveAudioStream {
    _audio ??= _audioData
        .receiveBroadcastStream()
        .map((it) => it as Float32List);
    return _audio!;
  }
  
  Stream<Float32List> getChunkedAudioStream() async* {
    log("GET");
    await for(final data in liveAudioStream) {
      _chunkedBuffer.addAll(data);

      if(_chunkedBuffer.length >= _chunkSize) {
        yield Float32List.fromList(_chunkedBuffer.sublist(0, _chunkSize));
        _chunkedBuffer.removeRange(0, _chunkSize);
      }
    }
  }
  
  Stream<int> get micEvents {
    return _micEvents
        .receiveBroadcastStream()
        .map((it) => it as int);
  }

  Future<void> startRecording() async {
    await _methodChannel.invokeMethod("startRecording");
  }

  Future<void> stopRecording() async {
    await _methodChannel.invokeMethod("stopRecording");
  }
}
