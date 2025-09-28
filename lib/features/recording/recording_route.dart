import 'package:ai_scribe_copilot/ext/pad.dart';
import 'package:ai_scribe_copilot/features/recording/bloc/event.dart';
import 'package:ai_scribe_copilot/features/recording/bloc/recording_bloc.dart';
import 'package:ai_scribe_copilot/features/recording/bloc/state.dart';
import 'package:ai_scribe_copilot/features/recording/ui/mic_visualizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform_ui/platform_ui.dart';

class RecordingRoute extends StatelessWidget {
  const RecordingRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: AppBar(),
      cupertinoBar: CupertinoNavigationBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<RecordingBloc, RecordingState>(
            builder: (context, state) {
              if (state is IdleRecordingState) {
                return Center(
                  child: PlatformFilledButton(
                    onPressed: () {
                      context.read<RecordingBloc>().add(StartRecordingEvent());
                    },
                    shape: CircleBorder(),
                    child: Icon(Icons.mic, size: 64).pad(),
                  ),
                );
              } else {
                final micController = context
                    .read<RecordingBloc>()
                    .microphoneController;
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 256,
                          child: MicVisualizer(
                            audioStream: micController.liveAudioStream,
                          ).pad()
                      ),

                      PlatformFilledButton(
                        onPressed: () {
                          context.read<RecordingBloc>().add(StopRecordingEvent());
                        },
                        shape: CircleBorder(),
                        child: Icon(Icons.pause, size: 64).pad(),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      )
    );
  }
}
