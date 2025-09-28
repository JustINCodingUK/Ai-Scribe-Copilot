abstract interface class RecordingEvent {}

class StartRecordingEvent implements RecordingEvent {}

class StopRecordingEvent implements RecordingEvent {}

class InitializedEvent implements RecordingEvent {}