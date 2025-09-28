import 'package:ai_scribe_copilot/ext/date.dart';
import 'package:ai_scribe_copilot/ext/pad.dart';
import 'package:flutter/material.dart';
import 'package:platform_ui/platform_ui.dart';

class WelcomeBar extends StatelessWidget {
  const WelcomeBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.primary,
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlatformText(
                  "Welcome\nDoctor!",
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ).padSymmetric(vertical: 2),

                PlatformText(
                  DateTime.now().date,
                  style: Theme.of(context).textTheme.titleSmall,
                ).padSymmetric(vertical: 2),
              ],
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: Image.asset("assets/icon.png", height: 150, width: 150),
          ),
        ],
      ).pad(padding: 16),
    );
  }
}
