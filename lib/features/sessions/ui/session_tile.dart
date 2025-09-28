import 'package:ai_scribe_copilot/ext/date.dart';
import 'package:ai_scribe_copilot/model/session.dart';
import 'package:flutter/material.dart';
import 'package:platform_ui/platform_ui.dart';

class SessionTile extends StatelessWidget {
  final Session session;
  final void Function() onClick;
  final int random;

  const SessionTile(
    this.session, {
    required this.onClick,
    required this.random,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(session.startTime).date;
    return InkWell(
      onTap: onClick,
      child: Card(
        color: _colorMap.keys.toList()[random],
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlatformText(
                    date,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Icon(
                Icons.play_circle_fill,
                color: _colorMap.values
                    .toList()[random], // Customize the icon color
              ),
            ],
          ),
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
