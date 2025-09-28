import 'dart:developer';

import 'package:ai_scribe_copilot/model/patient.dart';
import 'package:ai_scribe_copilot/network/backend_http_client.dart';

class PatientRepository {

  final BackendHttpClient _client;

  PatientRepository(this._client);

  Stream<Patient> getAllPatientsForUserId(String userId) {
    return _client.getPatientsForUserId(userId);
  }

  Future<Patient> createPatient({required String patientName, required String id}) async {
    log("message");
    final patientId = await _client.createPatient(name: patientName, userId: id);

    return Patient(patientId: patientId, name: patientName);
  }
}