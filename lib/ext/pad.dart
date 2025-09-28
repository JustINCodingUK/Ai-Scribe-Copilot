import 'package:flutter/cupertino.dart';

extension Pad on Widget {
  Widget pad({double padding = 8}) {
    return Padding(padding: EdgeInsetsGeometry.all(padding), child: this);
  }

  Widget padSymmetric({double horizontal = 8, double vertical = 8}) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: this,
    );
  }
}
