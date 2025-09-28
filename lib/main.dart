import 'package:ai_scribe_copilot/cache/cache_db.dart';
import 'package:ai_scribe_copilot/routing.dart';
import 'package:ai_scribe_copilot/theme/theme.dart';
import 'package:ai_scribe_copilot/theme/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:provider/provider.dart';

import 'cache/cache_manager.dart';
import 'data/patient_repository.dart';
import 'data/session_repository.dart';
import 'network/backend_http_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PlatformInitializer.init();
  final db = await getDb();
  runApp(AiScribeCopilotApplication(db));
}

class AiScribeCopilotApplication extends StatelessWidget {
  final CacheDatabase db;

  const AiScribeCopilotApplication(this.db, {super.key});

  @override
  Widget build(BuildContext context) {
    Widget app;
    final brightness = View
        .of(context)
        .platformDispatcher
        .platformBrightness;
    TextTheme textTheme = createTextTheme(
        context, "Nunito Sans", "Roboto Mono");
    MaterialTheme theme = MaterialTheme(textTheme);
    if (PlatformInitializer.platform == Platform.android) {
      app = MaterialApp.router(
          routerConfig: getRouter(db),
          theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      );
    } else {
      app = CupertinoApp.router(
          routerConfig: getRouter(db),
          theme: CupertinoThemeData(
            primaryColor: Color(0xff4c662b),
            brightness: brightness,
            textTheme: CupertinoTextThemeData(textStyle: textTheme.bodyLarge),
          ),
      );
    }

    return MultiProvider(
      providers: [
        Provider<BackendHttpClient>(
          create: (_) =>
              BackendHttpClient("https://scribeai-954620301379.europe-west1.run.app"),
        ),
        Provider<CacheManager>(create: (_) => CacheManager(db)),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<PatientRepository>(
            create: (context) => PatientRepository(context.read()),
          ),
          RepositoryProvider<SessionRepository>(
            create: (context) =>
                SessionRepository(context.read(), context.read()),
          ),
        ],
        child: app,
      ),
    );
  }
}
