import 'dart:io' show Platform;
import 'package:platform_ui/platform_ui.dart' as platform_ui;

class PlatformInitializer {

  static platform_ui.Platform platform = platform_ui.Platform.unknown;

  static void init() {
    if(Platform.isAndroid) {
      platform = platform_ui.Platform.android;
    } else {
      platform = platform_ui.Platform.ios;
    }
  }

}