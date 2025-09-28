import 'package:ai_scribe_copilot/ext/pad.dart';
import 'package:ai_scribe_copilot/model/patient.dart';
import 'package:flutter/material.dart';
import 'package:platform_ui/platform_ui.dart';

class PatientTile extends StatelessWidget {
  final Patient patient;
  final int random;
  final void Function() onClick;

  const PatientTile(this.patient, {required this.random, required this.onClick, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              color: _colorMap.values.toList()[random],
            ).pad(),
            PlatformText(
              patient.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ).padSymmetric(horizontal: 2),
          ],
        ),
      ),
    );
  }
}

final _colorMap = {
  Colors.lightGreen.shade50: Colors.green,
  Colors.lightBlue.shade50: Colors.blue,
  Colors.orange.shade50: Colors.orange,
  Colors.white: Colors.blue,
};