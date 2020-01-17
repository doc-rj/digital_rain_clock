import 'dart:math';
import 'package:flutter/material.dart';

/// This widget is a random glyph from a subset of the YOzREFM font, as defined
/// in the charset list.
class Char extends StatelessWidget {
  const Char({
    Key key,
    @required this.fontSize,
    @required this.color,
    @required this.shadowColor,
    this.opacity = 1.0,
  })  : assert(fontSize != null),
        assert(color != null),
        assert(shadowColor != null),
        assert(opacity != null),
        super(key: key);

  final double fontSize;
  final Color color;
  final Color shadowColor;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Text(
      charset[Random().nextInt(charset.length)],
      style: TextStyle(
        fontFamily: 'YOzREFM',
        fontSize: fontSize,
        color: color.withOpacity(opacity),
        shadows: [
          Shadow(
            offset: Offset(0.0, 0.0),
            blurRadius: 3.0,
            color: shadowColor,
          ),
        ],
      ),
    );
  }

  /// subset of characters from the YOzREFM font that best depict digital rain;
  /// glyphs in the 0xff66 to 0xff9d range work well for the typewriter form of
  /// katakana.
  static const charset = [
    'x',
    '1',
    '4',
    '6',
    '7',
    '8',
    '\u{01fe}',
    '\u{ff66}',
    '\u{ff67}',
    '\u{ff68}',
    '\u{ff69}',
    '\u{ff70}',
    '\u{ff71}',
    '\u{ff72}',
    '\u{ff73}',
    '\u{ff74}',
    '\u{ff75}',
    '\u{ff76}',
    '\u{ff77}',
    '\u{ff78}',
    '\u{ff79}',
    '\u{ff7a}',
    '\u{ff7b}',
    '\u{ff7c}',
    '\u{ff7d}',
    '\u{ff7e}',
    '\u{ff7f}',
    '\u{ff80}',
    '\u{ff81}',
    '\u{ff82}',
    '\u{ff83}',
    '\u{ff84}',
    '\u{ff85}',
    '\u{ff86}',
    '\u{ff87}',
    '\u{ff88}',
    '\u{ff89}',
    '\u{ff8a}',
    '\u{ff8b}',
    '\u{ff8c}',
    '\u{ff8d}',
    '\u{ff8e}',
    '\u{ff8f}',
    '\u{ff90}',
    '\u{ff91}',
    '\u{ff92}',
    '\u{ff93}',
    '\u{ff94}',
    '\u{ff95}',
    '\u{ff96}',
    '\u{ff97}',
    '\u{ff98}',
    '\u{ff99}',
    '\u{ff9a}',
    '\u{ff9b}',
    '\u{ff9c}',
    '\u{ff9d}',
  ];
}
