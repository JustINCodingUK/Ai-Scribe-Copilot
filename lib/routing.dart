import 'package:ai_scribe_copilot/cache/cache_db.dart';
import 'package:ai_scribe_copilot/cache/cache_manager.dart';
import 'package:ai_scribe_copilot/data/patient_repository.dart';
import 'package:ai_scribe_copilot/data/session_repository.dart';
import 'package:ai_scribe_copilot/features/patients/bloc/event.dart';
import 'package:ai_scribe_copilot/features/patients/bloc/patients_bloc.dart';
import 'package:ai_scribe_copilot/features/recording/bloc/recording_bloc.dart';
import 'package:ai_scribe_copilot/features/recording/recording_route.dart';
import 'package:ai_scribe_copilot/features/sessions/bloc/event.dart';
import 'package:ai_scribe_copilot/features/sessions/bloc/sessions_bloc.dart';
import 'package:ai_scribe_copilot/features/sessions/sessions_route.dart';
import 'package:ai_scribe_copilot/native/microphone_controller.dart';
import 'package:ai_scribe_copilot/network/backend_http_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'features/patients/patients_route.dart';

enum Routes {
  patients,
  sessions,
  recording;

  String route({String? arg1, String? arg2}) {
    switch (this) {
      case Routes.patients:
        return "/";
      case Routes.sessions:
        return "/sessions/$arg1/$arg2";
      case recording:
        return "/recording/$arg1";
    }
  }
}

GoRouter getRouter(CacheDatabase db) {
  return GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) {
          return BlocProvider<PatientsBloc>(
                create: (context) =>
                    PatientsBloc(context.read())
                      ..add(GetPatientsEvent("user_123")),
                child: PatientsRoute(),
          );
        },
      ),

      GoRoute(
        path: "/sessions/:patientId/:patientName",
        builder: (context, state) {
          return BlocProvider<SessionsBloc>(
            create: (context) {
              final id = state.pathParameters["patientId"] as String;
              final name = state.pathParameters["patientName"] as String;
              return SessionsBloc(context.read())
                ..add(GetSessionsEvent(patientId: id, patientName: name));
            },
            child: SessionsRoute(),
          );
        },
      ),

      GoRoute(
        path: "/recording/:sessionId",
        builder: (context, state) {
          return BlocProvider(
            create: (context) {
              final id = state.pathParameters["sessionId"] as String;
              return RecordingBloc(
                sessionId: id,
                repository: context.read(),
                microphoneController: MicrophoneController(),
              );
            },
            child: RecordingRoute(),
          );
        },
      ),
    ],
  );
}
