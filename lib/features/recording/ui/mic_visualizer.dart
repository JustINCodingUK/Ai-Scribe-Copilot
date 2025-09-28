import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:ai_scribe_copilot/ext/pad.dart';
import 'package:flutter/material.dart';

class MicVisualizer extends StatefulWidget {
  final Stream<Float32List> audioStream;

  const MicVisualizer({super.key, required this.audioStream});

  @override
  _MicVisualizerState createState() => _MicVisualizerState();
}

class _MicVisualizerState extends State<MicVisualizer> {
  late StreamSubscription<Float32List> _audioSubscription;
  double _currentLevel = 0.0;

  @override
  void initState() {
    super.initState();
    _audioSubscription = widget.audioStream.listen((audioChunk) {
      _updateLevel(audioChunk);
    });
  }

  void _updateLevel(Float32List audioChunk) {
    double sumOfSquares = 0.0;
    for (var sample in audioChunk) {
      sumOfSquares += sample * sample;
    }
    double rms = sqrt((sumOfSquares / audioChunk.length));

    setState(() {
      _currentLevel = rms;
    });
  }

  @override
  void dispose() {
    _audioSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(9, (it) {
        int scale = it;
        if(scale>=5) {
          scale=9-it;
        }
        return MicVisualizerBar(level: _currentLevel, scale: scale,).pad();
      }),
    );
  }
}

class MicVisualizerBar extends StatelessWidget {
  final double level;
  final int scale;
  const MicVisualizerBar({super.key, required this.level, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.0,
      height: level * 100 * scale,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}