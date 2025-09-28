import 'package:platform_ui/platform_ui.dart';
import 'package:flutter/material.dart' as m3;
import 'package:flutter/cupertino.dart' as cupertino;

class PlatformText extends PlatformWidget {
  final String data;
  final m3.TextAlign? textAlign;
  final m3.TextOverflow? overflow;
  final int? maxLines;
  final m3.TextDecoration? decoration;
  final m3.TextStyle? style;

  PlatformText(
    this.data, {
    super.key,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.decoration,
    this.style,
  });

  @override
  m3.Widget build(m3.BuildContext context) {
    if(platform == Platform.android) {
      return m3.Text(
        data,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        style: style,
      );
    } else {
      return cupertino.Text(
        data,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        style: style,
      );
    }
  }
}