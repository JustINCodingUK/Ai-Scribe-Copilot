import 'dart:math';

import 'package:ai_scribe_copilot/ext/pad.dart';
import 'package:ai_scribe_copilot/features/sessions/bloc/event.dart';
import 'package:ai_scribe_copilot/features/sessions/bloc/sessions_bloc.dart';
import 'package:ai_scribe_copilot/features/sessions/bloc/state.dart';
import 'package:ai_scribe_copilot/features/sessions/ui/session_tile.dart';
import 'package:ai_scribe_copilot/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_ui/platform_ui.dart';

class SessionsRoute extends StatelessWidget {
  SessionsRoute({super.key});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionsBloc, SessionState>(
      buildWhen: (previous, current) {
        return current is SessionsReceivedState ||
            current is SessionsLoadingState ||
            current is SessionsLoadingFailedState;
      },
      listenWhen: (previous, current) {
        return current is SessionCreationInProgressState ||
            current is SessionCreatedState ||
            current is SessionCreationFailedState;
      },
      builder: (context, state) {
        Widget child;
        if (state is SessionsReceivedState) {
          child = Column(
            children: [
              PlatformText(
                "Patient Recordings",
                style: Theme.of(context).textTheme.titleLarge,
              ).pad(),

              PlatformText(
                state.patientName,
                style: Theme.of(context).textTheme.bodyLarge,
              ).padSymmetric(vertical: 2),

              SizedBox(height: 16),

              ListView.builder(
                itemCount: state.sessions.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final random = Random().nextInt(4);
                  final session = state.sessions[index];
                  return SessionTile(
                    session,
                    onClick: () {},
                    random: random,
                  ).pad();
                },
              ),
            ],
          );
        } else if (state is SessionsLoadingState) {
          child = Center(child: CircularProgressIndicator());
        } else {
          child = Column(
            children: [
              PlatformText(
                "There was an error in loading the data",
                style: Theme.of(context).textTheme.bodyLarge,
              ).pad(),

              PlatformFilledButton(
                onPressed: () =>
                    context.read<SessionsBloc>().add(GetSessionsEvent()),
                child: Text("Retry"),
              ),
            ],
          );
        }
        return PlatformScaffold(
          appBar: AppBar(),
          cupertinoBar: CupertinoNavigationBar(),
          actionButton: FloatingActionButton(
            onPressed: () {
              context.read<SessionsBloc>().add(CreateSessionEvent());
            },
            child: Icon(Icons.add),
          ),
          body: child,
        );
      },
      listener: (context, state) {
        if (state is SessionCreationInProgressState) {
          showDialog(
            context: context,
            builder: (context) => Center(child: CircularProgressIndicator(),),
          );
        } else if (state is SessionCreationFailedState) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text(state.message),
              );
            },
          );
        } else {
          state as SessionCreatedState;
          context.push(Routes.recording.route(arg1: state.sessionId));
        }
      },
    );
  }
}
