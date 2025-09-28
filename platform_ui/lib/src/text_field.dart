import 'package:flutter/material.dart' as material;
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/widgets.dart';
import 'platform_widget.dart';
import 'platform.dart';

class PlatformTextField extends PlatformWidget {
  final String hint;
  final double? width;
  final Widget? leading;
  final material.TextEditingController controller;
  final bool isPassword;
  final void Function(String)? onChanged;
  final String? errorText;

  PlatformTextField(
      {required this.hint,
      this.width,
      this.leading,
      required this.controller,
      super.key,
      this.isPassword = false,
      this.onChanged,
      this.errorText});

  @override
  material.Widget build(material.BuildContext context) {
    switch (platform) {
      case Platform.android:
      case Platform.linux:
      case Platform.web:
      case Platform.windows:
        return material.SizedBox(
          width: width,
          child: material.TextField(
            controller: controller,
            decoration: material.InputDecoration(
              icon: leading,
              filled: true,
              fillColor:
                  material.Theme.of(context).colorScheme.secondaryContainer,
              errorText: errorText,
              border: material.OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32))),
              label: material.Text(hint),
            ),
            obscureText: isPassword,
            onChanged: onChanged,
          ),
        );

      case Platform.ios:
      case Platform.macos:
        return material.SizedBox(
          width: width,
          child: cupertino.CupertinoTextField(
            prefix: leading,
            placeholder: hint,
            onChanged: onChanged,
          ),
        );
      case Platform.unknown:
        return material.Container();
    }
  }
}
