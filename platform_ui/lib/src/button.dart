import 'package:flutter/material.dart' as material;
import 'package:flutter/cupertino.dart' as cupertino;
import 'platform_widget.dart';
import '../src/platform.dart';

class PlatformButton extends PlatformWidget {
  final void Function()? onPressed;
  final material.Widget child;

  PlatformButton({super.key, required this.child, required this.onPressed});

  @override
  material.Widget build(material.BuildContext context) {
    switch (platform) {
      case Platform.android:
      case Platform.linux:
      case Platform.windows:
      case Platform.web:
        return material.TextButton(
          onPressed: onPressed,
          child: child,
        );


      case Platform.ios:
      case Platform.macos:
        return cupertino.CupertinoButton(onPressed: onPressed, child: child);
      case Platform.unknown:
        return material.Container();
    }
  }
}

class PlatformFilledButton extends PlatformButton {
  final material.OutlinedBorder? shape;

  PlatformFilledButton(
      {super.key, required super.child, required super.onPressed, this.shape});

  @override
  material.Widget build(material.BuildContext context) {
    switch (platform) {
      case Platform.android:
      case Platform.linux:
      case Platform.windows:
      case Platform.web:
        return material.ElevatedButton(
            style: material.ElevatedButton.styleFrom(
              backgroundColor: material.Theme.of(context).colorScheme.primary,
              foregroundColor: material.Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: onPressed,
            child: child);


      case Platform.ios:
      case Platform.macos:
        return cupertino.CupertinoButton.filled(
            onPressed: onPressed, child: child);
      case Platform.unknown:
        return material.Container();
    }
  }
}
