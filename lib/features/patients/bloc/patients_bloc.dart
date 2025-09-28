import 'dart:developer';

import 'package:ai_scribe_copilot/data/patient_repository.dart';
import 'package:ai_scribe_copilot/features/patients/bloc/event.dart';
import 'package:ai_scribe_copilot/features/patients/bloc/state.dart';
import 'package:ai_scribe_copilot/model/patient.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientsBloc extends Bloc<PatientEvent, PatientState> {
  final PatientRepository _repository;

  List<Patient> patients = [];

  PatientsBloc(this._repository) : super(LoadingState()) {
    on<GetPatientsEvent>((event, emit) async {
      try {
        patients = await _repository
            .getAllPatientsForUserId(event.userId)
            .toList();
        emit(PatientsReceivedState(patients));
      } catch(e) {
        log(e.toString());
        emit(GetFailedState());
      }
    });

    on<CreatePatientEvent>((event, emit) async {
      emit(PatientInCreationState());
      try {
        final patient = await _repository.createPatient(
          patientName: event.name,
          id: event.userId,
        );

        emit(PatientCreatedState(patient));
        add(GetPatientsEvent("user_123"));
      } catch (e) {
        log("ERRROR");
        log(e.toString());
        emit(
          PatientCreationFailedState(
            "Couldn't create record for new patient, please try again later",
          ),
        );
      }
    });

    on<SearchPatientsEvent>((event, emit) {
      final newList = patients.where((it) => it.name.startsWith(event.phrase)).toList();
      emit(PatientsReceivedState(newList));
    });

    on<BeginPatientCreationEvent>((event, emit) {
      emit(BeginPatientCreationState());
    });
  }
}
