import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TerminalAnimation extends StatelessWidget {
  TerminalAnimation({
    Key key,
    this.ideograph,
    this.ideographStyle,
    this.startCursorOn = false,
    @required this.message,
    @required this.messageStyle,
    @required this.cursorStyle,
    @required this.controller,
  })  : assert(startCursorOn != null),
        assert(message != null),
        assert(messageStyle != null),
        assert(cursorStyle != null),
        assert(controller != null),
        startCursor = StepTween(
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
        cursorOnSpan = TextSpan(
          text: '\u{2587}',
          style: cursorStyle,
        ),
        cursorOffSpan = TextSpan(
          text: '\u{00a0}',
          style: cursorStyle,
        ),
        super(key: key);

  /// the suggested duration provides a good speed for animating the messages,
  /// enough time for reading them, and blinks the cursor at a standard rate
  static const kSuggestedDuration = const Duration(milliseconds: 5500);
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

  final TextSpan cursorOnSpan;
  final TextSpan cursorOffSpan;

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
    final spans = List<TextSpan>();
    if (_shouldShowIdeograph()) {
      spans.add(TextSpan(
        text: ideograph.substring(0, charCount.value == 0 ? 0 : 1),
        style: ideographStyle,
      ));
    }
    spans.add(TextSpan(
      text: _buildMessage(),
      style: messageStyle,
    ));
    spans.add(_shouldShowCursor() ? cursorOnSpan : cursorOffSpan);
    return spans;
  }

  String _buildMessage() {
    final prefix = _shouldShowIdeograph() ? '\u{2005}' : '';
    final endIndex = max(0, charCount.value - (_shouldShowIdeograph() ? 1 : 0));
    return prefix + message.substring(0, endIndex) + '\u{2005}';
  }

  bool _shouldShowCursor() {
    final textLength = message.length + (_shouldShowIdeograph() ? 1 : 0);
    if (charCount.value == 0) {
      int blinkValue = startCursor.value % 2;
      return startCursorOn ? blinkValue == 0 : blinkValue != 0;
    } else if (charCount.value == textLength) {
      return endCursor.value % 2 == 0;
    }
    return true;
  }

  bool _shouldShowIdeograph() {
    return ideograph != null && ideographStyle != null;
  }
}
