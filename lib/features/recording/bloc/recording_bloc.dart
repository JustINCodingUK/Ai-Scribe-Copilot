import 'dart:async';

import 'package:ai_scribe_copilot/data/session_repository.dart';
import 'package:ai_scribe_copilot/features/recording/bloc/event.dart';
import 'package:ai_scribe_copilot/features/recording/bloc/state.dart';
import 'package:ai_scribe_copilot/model/audio_chunk.dart';
import 'package:ai_scribe_copilot/native/microphone_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordingBloc extends Bloc<RecordingEvent, RecordingState> {
  final SessionRepository repository;
  final MicrophoneController microphoneController;
  final String sessionId;

  var _chunkCount = 1;
  StreamSubscription<AudioChunk>? sub;

  RecordingBloc({
    required this.sessionId,
    required this.repository,
    required this.microphoneController,
  }) : super(IdleRecordingState()) {
    on<StartRecordingEvent>((event, emit) async {
      _chunkCount = await repository.getLatestChunkFor(sessionId);
      await microphoneController.startRecording();
      await Future.delayed(
          Duration(seconds: 1),
          () {
            sub = repository.startStreaming(
              sessionId,
              microphoneController.getChunkedAudioStream().map(
                    (it) => AudioChunk(
                  number: _chunkCount++,
                  data: it,
                  isLast: state is IdleRecordingState,
                ),
              ),
            );
            emit(RecordingInProgressState());
            microphoneController.micEvents.listen((it) {
              if(it == 0) {
                add(StopRecordingEvent());
              } else {
                add(StartRecordingEvent());
              }
            });
          }
      );
    });

    on<StopRecordingEvent>((event, emit) {
      sub?.cancel();
      emit(IdleRecordingState());
    });
  }
}
