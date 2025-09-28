import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:ai_scribe_copilot/model/session.dart';
import 'package:ai_scribe_copilot/network/requests.dart';
import 'package:http/http.dart';

import '../model/patient.dart';

class BackendHttpClient {
  final String baseUrl;

  BackendHttpClient(this.baseUrl);

  Future<String> createNewSession(Patient patient) async {
    final request = CreateSessionRequest(
      patientId: patient.patientId,
      userId: "user_123",
      patientName: patient.name,
      status: "recording",
      startTime: DateTime.now().toIso8601String(),
      templateId: "new_patient_template",
    ).toJson();

    final url = Uri.parse("$baseUrl/v1/upload-session");
    final response = await post(
      url,
      headers: {"Content-Type": "application/json"},
      body: request,
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body["sessionId"];
    }
    throw Exception("Failed to create session");
  }

  Future<bool> uploadChunk({
    required String path,
    required Float32List audioData,
  }) async {
    final url = Uri.parse(path);
    final byteBuffer = ByteData(audioData.length * 4);

    for (var i = 0; i < audioData.length; i++) {
      byteBuffer.setFloat32(i * 4, audioData[i], Endian.little);
    }


    try {
      await put(url, headers: {"Content-Type":"application/octet-stream"}, body: byteBuffer.buffer.asUint8List());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<String> getUploadUrl({
    required String sessionId,
    required int chunkNumber,
    required String mimeType,
  }) async {
    final request = GetUploadUrlRequest(
      sessionId: sessionId,
      chunkNumber: chunkNumber,
      mimeType: mimeType,
    ).toJson();

    final url = Uri.parse("$baseUrl/v1/get-presigned-url");
    final response = await post(
      url,
      headers: {"Content-Type": "application/json"},
      body: request,
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return "$baseUrl${body["url"]}";
    }
    throw Exception("Failed to get upload url");
  }

  Future<void> notifyChunkUploaded({
    required int chunkNumber,
    required String sessionId,
    required bool isLast,
    required String publicUrl,
  }) async {
    final request = AudioChunkUploadedRequest(
      chunkNumber: chunkNumber,
      isLast: isLast,
      publicUrl: publicUrl,
      sessionId: sessionId,
      mimeType: "audio/wav",
      gcsPath: publicUrl,
      totalChunksClient: chunkNumber,
    ).toJson();

    final url = Uri.parse("$baseUrl/v1/notify-chunk-uploaded");
    await post(
      url,
      headers: {"Content-Type": "application/json"},
      body: request,
    );
  }

  Stream<Patient> getPatientsForUserId(String userId) async* {
    final url = Uri.parse("$baseUrl/v1/patients?userId=$userId");
    final response = await get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      for (Map<String, dynamic> patient in body["patients"]) {
        yield Patient(patientId: patient["patientId"]!, name: patient["name"]!);
      }
    }
  }

  Future<String> createPatient({
    required String name,
    required String userId,
  }) async {
    final url = Uri.parse("$baseUrl/v1/add-patient-ext");
    final request = CreatePatientRequest(userId: userId, name: name).toJson();
    log("Creating patient");
    final response = await post(
      url,
      headers: {"Content-Type": "application/json"},
      body: request,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["patient"]["patientId"];
    } else {
      throw Exception("Failed to create patient");
    }
  }

  Stream<Session> getSessionsForPatient(String patientId) async* {
    final url = Uri.parse("$baseUrl/v1/fetch-session-by-patient/$patientId");
    final response = await get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      for (Map<String, dynamic> session in body["sessions"]) {
        yield Session(
          sessionId: session["id"]!,
          patient: Patient(
            patientId: session["patientId"]!,
            name: session["patientName"]!,
          ),
          status: session["status"]!,
          userId: session["userId"]!,
          startTime: session["startTime"]!,
          templateId: session["templateId"]!,
        );
      }
    }
  }

  Future<bool> getStatus() async {
    final url = Uri.parse("$baseUrl/v1/patients?userId=user_123");
    try {
      final response = await get(url);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
