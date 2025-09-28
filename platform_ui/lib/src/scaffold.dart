import 'package:flutter/material.dart' as material;
import 'package:flutter/cupertino.dart' as cupertino;
import 'platform.dart';
import 'platform_widget.dart';

class PlatformScaffold extends PlatformWidget {
  final material.Widget body;
  final material.AppBar? appBar;
  final cupertino.CupertinoNavigationBar? cupertinoBar;
  final material.Widget? actionButton;
  final material.Widget? bottomNavigationBar;
  final material.FloatingActionButtonLocation? fabLocation;

  PlatformScaffold(
      {super.key,
      this.actionButton,
      this.appBar,
      this.cupertinoBar,
      required this.body,
      this.bottomNavigationBar,
      this.fabLocation});

  @override
  material.Widget build(material.BuildContext context) {
    switch (platform) {
      case Platform.android:
      case Platform.web:
      case Platform.linux:
      case Platform.windows:
        return material.Scaffold(
          appBar: appBar,
          body: body,
          floatingActionButton: actionButton,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButtonLocation: fabLocation,
        );

      case Platform.ios:
      case Platform.macos:
        return cupertino.CupertinoPageScaffold(
          navigationBar: cupertinoBar,
          child: body,
        );
      case Platform.unknown:
        return material.Container();
    }
  }
}
