import 'package:flutter/material.dart';

/*
 * This class extends Shadow to use BlurStyle.solid, which provides a better
 * look behind translucent shapes; Can remove this later on if the BoxShadow
 * constructor takes a BlurStyle.
 */
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
