import 'package:ai_scribe_copilot/data/session_repository.dart';
import 'package:ai_scribe_copilot/features/sessions/bloc/event.dart';
import 'package:ai_scribe_copilot/features/sessions/bloc/state.dart';
import 'package:ai_scribe_copilot/model/patient.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionsBloc extends Bloc<SessionEvent, SessionState> {
  final SessionRepository _repository;

  String? id;
  String? name;

  SessionsBloc(this._repository) : super(SessionsLoadingState()) {
    on<GetSessionsEvent>((event, emit) async {
      if(id == null) {
        id = event.patientId;
        name = event.patientName;
      }
      final sessions = await _repository
          .getSessionsForPatient(id!)
          .toList();
      emit(SessionsReceivedState(sessions, name!));
    });

    on<CreateSessionEvent>((event, emit) async {
      emit(SessionCreationInProgressState());
      try {
        final patient = Patient(patientId: id!, name: name!);
        final sessionId = await _repository.createNewSession(patient);
        emit(SessionCreatedState(sessionId));
      } catch (e) {
        emit(
          SessionCreationFailedState(
            "Couldn't create new session, please try again later!",
          ),
        );
      }
    });
  }
}
