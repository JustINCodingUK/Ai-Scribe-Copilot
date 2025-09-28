abstract interface class PatientEvent {}

class GetPatientsEvent implements PatientEvent {
  final String userId;

  GetPatientsEvent(this.userId);
}

class SearchPatientsEvent implements PatientEvent {
  final String phrase;

  SearchPatientsEvent(this.phrase);
}

class BeginPatientCreationEvent implements PatientEvent {}

class CreatePatientEvent implements PatientEvent {
  final String name;
  final String userId;

  CreatePatientEvent(this.name, this.userId);
}