import 'package:ai_scribe_copilot/model/session.dart';

abstract interface class SessionState {}

class SessionsReceivedState implements SessionState {
  final String patientName;
  final List<Session> sessions;

  SessionsReceivedState(this.sessions, this.patientName);
}

class SessionsLoadingState implements SessionState {}

class SessionsLoadingFailedState implements SessionState {}

class SessionCreationInProgressState implements SessionState {}

class SessionCreatedState implements SessionState {
  final String sessionId;

  SessionCreatedState(this.sessionId);
}

class SessionCreationFailedState implements SessionState {
  final String message;

  SessionCreationFailedState(this.message);
}