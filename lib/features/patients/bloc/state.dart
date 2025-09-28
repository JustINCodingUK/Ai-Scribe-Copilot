import 'package:ai_scribe_copilot/model/patient.dart';

abstract interface class PatientState {}

class PatientsReceivedState implements PatientState {
  final List<Patient> patients;

  PatientsReceivedState(this.patients);
}

class LoadingState implements PatientState {}

class GetFailedState implements PatientState {}

class BeginPatientCreationState implements PatientState {}

class PatientInCreationState implements PatientState {}

class PatientCreatedState implements PatientState {
  final Patient patient;
  
  PatientCreatedState(this.patient);
}

class PatientCreationFailedState implements PatientState {
  final String error;

  PatientCreationFailedState(this.error);
}