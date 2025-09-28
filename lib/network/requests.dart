import 'dart:convert';
import 'dart:typed_data';

abstract interface class Request {
  Map<String, dynamic> toMap();

  String toJson() => jsonEncode(toMap());
}

class CreateSessionRequest extends Request {
  final String patientId;
  final String userId;
  final String patientName;
  final String status;
  final String startTime;
  final String templateId;

  CreateSessionRequest({
    required this.patientId,
    required this.userId,
    required this.patientName,
    required this.status,
    required this.startTime,
    required this.templateId,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'userId': userId,
      'patientName': patientName,
      'status': status,
      'startTime': startTime,
      'templateId': templateId,
    };
  }
}

class GetUploadUrlRequest extends Request {
  final String sessionId;
  final int chunkNumber;
  final String mimeType;

  GetUploadUrlRequest({
    required this.sessionId,
    required this.chunkNumber,
    required this.mimeType,
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'chunkNumber': chunkNumber,
      'mimeType': mimeType,
    };
  }

}

class AudioChunkUploadedRequest extends Request {
  final int chunkNumber;
  final bool isLast;
  final String publicUrl;
  final String sessionId;
  final String mimeType;
  final String gcsPath;
  final int totalChunksClient;

  AudioChunkUploadedRequest({
    required this.chunkNumber,
    required this.isLast,
    required this.publicUrl,
    required this.sessionId,
    required this.mimeType,
    required this.gcsPath,
    required this.totalChunksClient,
  });

  Map<String, dynamic> toMap() {
    return {
      'chunkNumber': chunkNumber,
      'isLast': isLast,
      'publicUrl': publicUrl,
      'sessionId': sessionId,
      'mimeType': mimeType,
      'gcsPath': gcsPath,
      'totalChunksClient': totalChunksClient,
    };
  }
}

class CreatePatientRequest extends Request {
  final String userId;
  final String name;

  CreatePatientRequest({
    required this.userId,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
    };
  }
}