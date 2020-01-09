import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TerminalAnimation extends StatelessWidget {
  TerminalAnimation({
    Key key,
    this.startCursorOn = false,
    this.ideograph,
    this.ideographStyle,
    @required this.message,
    @required this.messageStyle,
    @required this.cursorStyle,
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
          end: message.length + (ideograph != null ? 1 : 0),
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
        cursorOn = TextSpan(
          text: '\u{2587}',
          style: cursorStyle,
        ),
        cursorOff = TextSpan(
          text: '\u{00a0}',
          style: cursorStyle,
        ),
        super(key: key);

  static const kDuration = const Duration(milliseconds: 5500);
  static const kStartSteps = 3;
  static const kEndSteps = 6;

  static const kStartInterval = const Interval(0.0, 0.2727);
  static const kTextInterval = const Interval(0.2727, 0.4545);
  static const kEndInterval = const Interval(0.4545, 1.0);

  final bool startCursorOn;
  final String ideograph;
  final String message;
  final TextStyle ideographStyle;
  final TextStyle messageStyle;
  final TextStyle cursorStyle;

  final Animation<double> controller;
  final Animation<int> startCursor;
  final Animation<int> charCount;
  final Animation<int> endCursor;

  final TextSpan cursorOn;
  final TextSpan cursorOff;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.clip,
      text: TextSpan(
        children: _buildTextSpans(),
      ),
    );
  }

  List<TextSpan> _buildTextSpans() {
    final spans = List<TextSpan>(ideograph != null ? 3 : 2);
    var spanIndex = 0;
    if (ideograph != null) {
      spans[spanIndex++] = TextSpan(
        text: ideograph.substring(0, charCount.value == 0 ? 0 : 1),
        style: ideographStyle,
      );
    }
    spans[spanIndex++] = TextSpan(
      text: _buildMessage(),
      style: messageStyle,
    );
    spans[spanIndex++] = _shouldShowCursor() ? cursorOn : cursorOff;
    return spans;
  }

  String _buildMessage() {
    final endIndex = max(0, charCount.value - (ideograph != null ? 1 : 0));
    final prefix = ideograph != null ? '\u{2005}' : '';
    return prefix + message.substring(0, endIndex) + '\u{2005}';
  }

  bool _shouldShowCursor() {
    final textLength = message.length + (ideograph != null ? 1 : 0);
    if (charCount.value == 0) {
      int blinkValue = startCursor.value % 2;
      return startCursorOn ? blinkValue == 0 : blinkValue != 0;
    } else if (charCount.value == textLength) {
      return endCursor.value % 2 == 0;
    }
    return true;
  }
}
