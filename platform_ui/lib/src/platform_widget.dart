import 'package:flutter/material.dart';
import 'package:platform_ui/src/platform_init.dart';
import 'platform.dart';

abstract class PlatformWidget extends StatelessWidget {

  final Platform platform = PlatformInitializer.platform;

  PlatformWidget({super.key});

}
