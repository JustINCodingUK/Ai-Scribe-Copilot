import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ai_scribe_copilot/model/audio_chunk.dart';
import 'package:ai_scribe_copilot/model/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cache/cache_manager.dart';
import '../model/patient.dart';
import '../network/backend_http_client.dart';

class SessionRepository {
  final BackendHttpClient _client;
  final CacheManager _cacheManager;

  var isTryingUpload = false;

  SessionRepository(this._client, this._cacheManager);

  Future<String> createNewSession(Patient patient) {
    return _client.createNewSession(patient);
  }

  StreamSubscription<AudioChunk> startStreaming(String sessionId, Stream<AudioChunk> audioStream) {
    return audioStream.listen((data) async {
      try {
        final url = await _client.getUploadUrl(
          sessionId: sessionId,
          chunkNumber: data.number,
          mimeType: "audio/wav",
        );
        final success = await _client.uploadChunk(
          path: url,
          audioData: data.data,
        );
        if (success) {
          await _client.notifyChunkUploaded(
            chunkNumber: data.number,
            sessionId: sessionId,
            isLast: data.isLast,
            publicUrl: url,
          );
          await setLatestChunkFor(sessionId, data.number);
        } else {
          await _cacheManager.saveChunk(
            sessionId: sessionId,
            chunkNumber: data.number,
            url: url,
            isLast: data.isLast,
            audioData: data.data,
          );
          tryUpload();
        }
      } catch (e) {
        await _cacheManager.saveChunk(
          sessionId: sessionId,
          chunkNumber: data.number,
          url: "",
          isLast: data.isLast,
          audioData: data.data,
        );
        tryUpload();
      }
    });
  }

  void tryUpload() {
    if (isTryingUpload) {
      return;
    }
    isTryingUpload = true;
    Timer.periodic(Duration(seconds: 5), (timer) async {
      final status = await _client.getStatus();
      if (status) {
        _cacheManager.getCache().listen(
          (data) async {
            if (data != null) {
              final audioData = await File(data.filePath).readAsBytes();
              final buffer = audioData.buffer;
              final floatData = buffer.asFloat32List(audioData.offsetInBytes, audioData.lengthInBytes ~/ 4);
              if (data.url.isEmpty) {
                final url = await _client.getUploadUrl(
                  sessionId: data.sessionId,
                  chunkNumber: data.chunkNumber,
                  mimeType: "audio/wav",
                );
                await _client.uploadChunk(path: url, audioData: floatData);
              } else {
                await _client.uploadChunk(path: data.url, audioData: floatData);
              }
              await _client.notifyChunkUploaded(
                chunkNumber: data.chunkNumber,
                sessionId: data.sessionId,
                isLast: data.isLast,
                publicUrl: data.url,
              );
              await setLatestChunkFor(data.sessionId, data.chunkNumber);
              await _cacheManager.clearCacheById(id: data.id!);
            }
          },
          onDone: () {
            timer.cancel();
            isTryingUpload = false;
          },
        );
      }
    });
  }

  Stream<Session> getSessionsForPatient(String patientId) {
    return _client.getSessionsForPatient(patientId);
  }

  Future<String> createSession(Patient patient) {
    return _client.createNewSession(patient);
  }

  Future<int> getLatestChunkFor(String sessionId) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getInt(sessionId) ?? 1;
  }

  Future<void> setLatestChunkFor(String sessionId, int chunk) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setInt(sessionId, chunk);
  }
}
