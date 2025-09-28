import 'package:ai_scribe_copilot/model/patient.dart';

class Session {

  final String sessionId;
  final Patient patient;

  final String status;
  final String userId;
  final String startTime;
  final String templateId;

  Session({
    required this.sessionId,
    required this.patient,
    required this.status,
    required this.userId,
    required this.startTime,
    required this.templateId,
  });

}