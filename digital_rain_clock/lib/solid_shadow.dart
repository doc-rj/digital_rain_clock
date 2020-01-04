import 'package:flutter/material.dart';

class SolidShadow extends Shadow {
  const SolidShadow({
    Color color = const Color(0xff000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    return Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, blurSigma);
  }
}
