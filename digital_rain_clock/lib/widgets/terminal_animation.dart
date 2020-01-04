import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TerminalAnimation extends StatelessWidget {

  TerminalAnimation({
    Key key,
    this.quickStart = false,
    @required this.text,
    @required this.textStyle,
    @required this.colors,
    @required this.controller,
  })  : startCursor = StepTween(
          begin: 0,
          end: quickStart ? kQuickStartSteps : kStartSteps,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: quickStart ? kQuickStartInterval : kStartInterval,
          ),
        ),
        charCount = StepTween(
          begin: 0,
          end: text.length,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: quickStart ? kQuickTextInterval : kTextInterval,
          ),
        ),
        endCursor = StepTween(
          begin: 0,
          end: quickStart ? kQuickEndSteps : kEndSteps,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: quickStart ? kQuickEndInterval : kEndInterval,
          ),
        ),
        super(key: key);

  static const kDuration = const Duration(seconds: 17);
  static const kQuickDuration = const Duration(seconds: 11);

  static const kStartSteps = 16;
  static const kQuickStartSteps = 4;
  static const kEndSteps = 15;
  static const kQuickEndSteps = 15;

  static const kStartInterval = const Interval(0.0, 0.4706);
  static const kTextInterval = const Interval(0.4706, 0.5588);
  static const kEndInterval = const Interval(0.5588, 1.0);

  static const kQuickStartInterval = const Interval(0.0, 0.1818);
  static const kQuickTextInterval = const Interval(0.1818, 0.3182);
  static const kQuickEndInterval = const Interval(0.3182, 1.0);

  final bool quickStart;
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
    final cursor = _shouldShowCursor() ? '\u{2005}\u{2587}' : '';
    final displayText = text.substring(0, charCount.value) + cursor;
    return Text(
      displayText,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
    );
  }

  bool _shouldShowCursor() {
    if (charCount.value == 0) {
      return startCursor.value % 2 == 0;
    } else if (charCount.value == text.length) {
      return endCursor.value % 2 == 0;
    }
    return true;
  }
}
