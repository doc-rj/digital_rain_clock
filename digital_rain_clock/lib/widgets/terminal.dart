import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../themes.dart';
import '../solid_box_shadow.dart';
import 'terminal_animation.dart';

class Terminal extends StatefulWidget {
  const Terminal(
      {@required this.text, @required this.widthFactor, @required this.colors});
  final String text;
  final double widthFactor;
  final Map colors;

  @override
  State createState() => new TerminalState();
}

class TerminalState extends State<Terminal> with TickerProviderStateMixin {
  TextStyle _textStyle;
  AnimationController _animationController;

  Timer _timer;
  String _date;
  String _displayText;

  @override
  void initState() {
    super.initState();
    _updateTextStyle();
    _animationController = AnimationController(
      duration: TerminalAnimation.kDuration,
      vsync: this,
    );
    _updateDate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _updateDate() {
    final dateTime = DateTime.now();
    String date = DateFormat.yMMMMd("en_US").format(dateTime);
    //String date = DateFormat.yMMMMEEEEd("en_US").format(dateTime);
    if (date != _date) {
      _date = date;
      _updateDisplayText();
    }
    _timer = Timer(
      Duration(minutes: 1) - Duration(seconds: dateTime.second),
      _updateDate,
    );
  }

  @override
  void didUpdateWidget(Terminal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _animationController.duration = TerminalAnimation.kQuickDuration;
      _updateDisplayText();
    }
    if (widget.colors != oldWidget.colors) {
      _updateTextStyle();
    }
  }

  void _updateDisplayText() {
    _displayText = "$_date * ${widget.text}";
    _animationController.reset();
    _animationController.forward();
  }

  void _updateTextStyle() {
    setState(() {
      _textStyle = TextStyle(
        fontFamily: 'CourierPrimeCodeItalic',
        fontSize: 16.0,
        height: 1.2,
        color: widget.colors[ColorElement.crt_text],
        shadows: [],
      );
    });
  }

  // todo: semantics
  @override
  Widget build(BuildContext context) {
    final width =
        (MediaQuery.of(context).size.width * widget.widthFactor) - 52.0;
    final padding = (width - _estimateTextWidth()) / 2;
    return Container(
      constraints: BoxConstraints.expand(
        height: _textStyle.fontSize * 1.2 + 6.0,
      ),
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      padding: EdgeInsets.only(left: 16.0 + max(0.0, padding), right: 16.0),
      decoration: BoxDecoration(
        color: widget.colors[ColorElement.crt_background].withOpacity(0.7),
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          SolidBoxShadow(
            blurRadius: 4,
            color: widget.colors[ColorElement.shadow].withOpacity(0.8),
            offset: Offset(0.5, 2),
          ),
        ],
      ),
      alignment: Alignment.bottomLeft,
      child: TerminalAnimation(
        quickStart:
            _animationController.duration == TerminalAnimation.kQuickDuration,
        text: _displayText,
        textStyle: _textStyle,
        colors: widget.colors,
        controller: _animationController,
      ),
    );
  }

  double _estimateTextWidth() {
    return _displayText.length * _textStyle.fontSize / 1.27;
  }
}
