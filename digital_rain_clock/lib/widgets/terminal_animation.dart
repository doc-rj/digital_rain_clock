import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TerminalAnimation extends StatelessWidget {
  TerminalAnimation({
    Key key,
    this.startCursorOn = false,
    @required this.text,
    @required this.textStyle,
    @required this.colors,
    @required this.controller,
  })  : startCursor = StepTween(
          begin: 0,
          end: kStartSteps,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: kStartInterval,
        )),
        charCount = StepTween(
          begin: 0,
          end: text.length,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: kTextInterval,
        )),
        endCursor = StepTween(
          begin: 0,
          end: kEndSteps,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: kEndInterval,
        )),
        super(key: key);

  static const kDuration = const Duration(milliseconds: 5500);
  static const kStartSteps = 3;
  static const kEndSteps = 6;

  static const kStartInterval = const Interval(0.0, 0.2727);
  static const kTextInterval = const Interval(0.2727, 0.4545);
  static const kEndInterval = const Interval(0.4545, 1.0);

  final bool startCursorOn;
  final String text;
  final TextStyle textStyle;
  final Map colors;

  final Animation<double> controller;
  final Animation<int> startCursor;
  final Animation<int> charCount;
  final Animation<int> endCursor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    // cursor is a half space followed by a block
    final cursor = _showCursor() ? '\u{2005}\u{2587}' : '\u{2005}\u{0020}';
    final displayText = text.substring(0, charCount.value) + cursor;
    return Text(
      displayText,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
    );
  }

  bool _showCursor() {
    if (charCount.value == 0) {
      int blinkValue = startCursor.value % 2;
      return startCursorOn ? blinkValue == 0 : blinkValue != 0;
    } else if (charCount.value == text.length) {
      return endCursor.value % 2 == 0;
    }
    return true;
  }
}
