abstract interface class SessionEvent {}

class CreateSessionEvent implements SessionEvent {}

class GetSessionsEvent implements SessionEvent {
  final String? patientId;
  final String? patientName;

  GetSessionsEvent({this.patientId, this.patientName});
}