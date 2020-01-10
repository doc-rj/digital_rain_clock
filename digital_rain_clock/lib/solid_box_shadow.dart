import 'package:flutter/material.dart';

/*
 * This class extends BoxShadow to use BlurStyle.solid, which provides a
 * better look behind translucent shapes; Can remove this later if BoxShadow
 * constructor takes a BlurStyle.
 */
class SolidBoxShadow extends BoxShadow {
  const SolidBoxShadow({
    Color color = const Color(0xff000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, blurSigma);
    assert(() {
      if (debugDisableShadows) result.maskFilter = null;
      return true;
    }());
    return result;
  }
}
