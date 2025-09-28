import 'package:ai_scribe_copilot/ext/pad.dart';
import 'package:ai_scribe_copilot/features/patients/bloc/event.dart';
import 'package:ai_scribe_copilot/features/patients/bloc/patients_bloc.dart';
import 'package:ai_scribe_copilot/features/patients/bloc/state.dart';
import 'package:ai_scribe_copilot/features/patients/ui/patient_tile.dart';
import 'package:ai_scribe_copilot/features/patients/ui/welcome_bar.dart';
import 'package:ai_scribe_copilot/routing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_ui/platform_ui.dart';

class PatientsRoute extends StatelessWidget {
  PatientsRoute({super.key});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientsBloc, PatientState>(
      buildWhen: (previous, current) {
        return (current is! BeginPatientCreationState &&
            current is! PatientCreatedState &&
            current is! PatientCreationFailedState &&
            current is! PatientInCreationState);
      },
      listenWhen: (previous, current) {
        return (current is BeginPatientCreationState ||
            current is PatientCreationFailedState ||
            current is PatientCreatedState ||
            current is PatientInCreationState);
      },
      listener: (context, state) {
        if(state is! BeginPatientCreationState) {
          Navigator.of(context).pop();
        }
        final patientName = TextEditingController();
        final buttonText = state is BeginPatientCreationState ? "Create" : "Ok";
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: PlatformText("Create new patient"),
              content: state is BeginPatientCreationState
                  ? PlatformTextField(
                      hint: "Patient's name",
                      controller: patientName,
                    )
                  : (state is PatientInCreationState
                        ? SizedBox(height: 128, child: Center(child: CircularProgressIndicator()),)
                        : Text(
                            state is PatientCreatedState
                                ? "Patient Created"
                                : "Some error occurred",
                          )),
              actions: [
                state is! PatientInCreationState
                    ? PlatformFilledButton(
                        onPressed: () {
                          if (state is BeginPatientCreationState) {
                            context.read<PatientsBloc>().add(
                              CreatePatientEvent(patientName.text, "user_123"),
                            );
                          } else {
                            Navigator.of(ctx).pop();
                            if(state is PatientCreatedState) {
                              context.read<PatientsBloc>().add(
                                GetPatientsEvent("user_123"),
                              );
                            }
                          }
                        },
                        child: PlatformText(buttonText),
                      )
                    : Container(),
              ],
            );
          },
        );
      },
      builder: (context, state) {
        Widget child;
        if (state is LoadingState) {
          child = Center(child: CircularProgressIndicator());
        } else if (state is PatientsReceivedState) {
          child = Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WelcomeBar(),
              SizedBox(height: 32),
              PlatformTextField(
                hint: "Search",
                controller: searchController,
                onChanged: (text) =>
                    context.read<PatientsBloc>().add(SearchPatientsEvent(text)),
              ).pad(),

              state.patients.isNotEmpty
                  ? ListView.builder(
                      itemCount: state.patients.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final element = state.patients[index];
                        return PatientTile(
                          element,
                          random: index%4,
                          onClick: () {
                            context.push(
                              Routes.sessions.route(
                                arg1: element.patientId,
                                arg2: element.name,
                              ),
                            );
                          },
                        ).pad();
                      },
                    )
                  : Center(child: Text("No patients found")),
            ],
          );
        } else {
          child = Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PlatformText(
                "There was an error in loading the data",
                style: Theme.of(context).textTheme.bodyLarge,
              ).pad(),

              PlatformFilledButton(
                onPressed: () => context.read<PatientsBloc>().add(
                  GetPatientsEvent(
                    "user_123",
                  ), // Reviewers, hardcoding this for now
                ),
                child: Text("Retry"),
              ),
            ],
          );
        }
        return PlatformScaffold(
          appBar: AppBar(title: Text("Scribe AI")),
          cupertinoBar: CupertinoNavigationBar(middle: Text("Scribe AI")),
          actionButton: FloatingActionButton(
            onPressed: () {
              context.read<PatientsBloc>().add(BeginPatientCreationEvent());
            },
            child: Icon(Icons.add),
          ),
          body: child,
        );
      },
    );
  }
}
