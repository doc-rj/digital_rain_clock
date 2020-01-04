import 'dart:math';
import 'package:flutter/material.dart';
import '../themes.dart';
import '../charset.dart';

class Char extends StatelessWidget {
  const Char({
    Key key,
    @required this.fontSize,
    @required this.color,
    @required this.colors,
    this.opacity = 1.0
  }) : super(key: key);

  final double fontSize;
  final Color color;
  final Map colors;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Text(
      charset[Random().nextInt(charset.length)],
      style: TextStyle(
        fontFamily: 'DigitalRain',
        fontSize: fontSize,
        color: color.withOpacity(opacity),
        shadows: [
          Shadow(
            offset: Offset(0.0, 0.0),
            blurRadius: 3.0,
            color: colors[ColorElement.char_shadow],
          ),
        ],
      ),
    );
  }
}
