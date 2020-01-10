import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../themes.dart';
import '../solid_box_shadow.dart';
import 'terminal_animation.dart';

class Terminal extends StatefulWidget {
  const Terminal({this.ideograph, @required this.text, @required this.colors});
  final String ideograph;
  final String text;
  final Map colors;

  @override
  State createState() => new TerminalState();
}

class TerminalState extends State<Terminal> with TickerProviderStateMixin {
  TextStyle _ideographStyle;
  TextStyle _textStyle;
  TextStyle _cursorStyle;
  AnimationController _animationController;

  Timer _timer;
  String _date;
  bool _startOn = false;
  int _index = 0;
  List _messages = [''];

  @override
  void initState() {
    super.initState();
    _updateDate();
    _updateTextStyles();
    _animationController = AnimationController(
      duration: TerminalAnimation.kSuggestedDuration,
      vsync: this,
    );
    _animationController.addStatusListener(_onAnimationStatus);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(Terminal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text ||
        widget.ideograph != oldWidget.ideograph) {
      _updateDisplayText();
    }
    if (widget.colors != oldWidget.colors) {
      _updateTextStyles();
    }
  }

  Future<void> _onAnimationStatus(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      await Future.delayed(Duration(milliseconds: 500));
      _animationController.reverse();
    } else if (status == AnimationStatus.dismissed) {
      setState(() {
        _startOn = !_startOn;
        _index = _index == _messages.length - 1 ? 0 : ++_index;
        _animationController.forward();
      });
    }
  }

  void _updateDate() {
    final dateTime = DateTime.now();
    String date = DateFormat.yMMMMEEEEd("en_US").format(dateTime);
    if (date != _date) {
      _date = date;
      _updateDisplayText();
    }
    _timer = Timer(
      Duration(minutes: 1) - Duration(seconds: dateTime.second),
      _updateDate,
    );
  }

  void _updateDisplayText() {
    setState(() {
      _messages.clear();
      _messages.add(_date);
      _messages.add(widget.text);
    });
  }

  void _updateTextStyles() {
    setState(() {
      _ideographStyle = TextStyle(
        fontFamily: 'YOzREFM',
        fontSize: 18.0,
        textBaseline: TextBaseline.ideographic,
        color: widget.colors[ColorElement.tty_text],
        shadows: [],
      );
      _textStyle = TextStyle(
        fontFamily: 'CourierPrimeCodeItalic',
        fontSize: 16.0,
        height: 1.2,
        color: widget.colors[ColorElement.tty_text],
        shadows: [],
      );
      _cursorStyle = TextStyle(
        fontFamily: 'DejaVuSansMono',
        fontSize: 16.0,
        height: 1.0,
        color: widget.colors[ColorElement.tty_text],
        shadows: [],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final opacity = widget.colors == ColorThemes.lightTheme ? 0.96 : 0.7;
    return Semantics(
      label: 'date and weather',
      value: _date + ' ${widget.text}',
      container: true,
      excludeSemantics: true,
      child: Container(
        constraints: BoxConstraints.expand(
          height: _textStyle.fontSize * 1.2 + 6.0,
        ),
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        decoration: BoxDecoration(
          color:
              widget.colors[ColorElement.tty_background].withOpacity(opacity),
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            SolidBoxShadow(
              blurRadius: 4,
              color: widget.colors[ColorElement.shadow].withOpacity(0.8),
              offset: Offset(0.5, 2),
            ),
          ],
        ),
        alignment: Alignment.bottomCenter,
        child: TerminalAnimation(
          startCursorOn: _startOn,
          ideograph: _index > 0 ? widget.ideograph : null,
          ideographStyle: _ideographStyle,
          message: _messages[_index],
          messageStyle: _textStyle,
          cursorStyle: _cursorStyle,
          controller: _animationController,
        ),
      ),
    );
  }
}
