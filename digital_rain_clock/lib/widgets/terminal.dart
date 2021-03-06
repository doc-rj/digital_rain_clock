import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../themes.dart';
import '../solid_box_shadow.dart';
import 'terminal_animation.dart';

class Terminal extends StatefulWidget {
  const Terminal({
    Key key,
    this.ideograph,
    @required this.text,
    @required this.semanticValue,
  })  : assert(text != null),
        assert(semanticValue != null),
        super(key: key);

  final String ideograph;
  final String text;
  final String semanticValue;

  @override
  State createState() => new TerminalState();
}

class TerminalState extends State<Terminal> with TickerProviderStateMixin {
  TextStyle _ideographStyle;
  TextStyle _textStyle;
  TextStyle _cursorStyle;
  AnimationController _animationController;

  Map _colors;
  Timer _timer;
  String _date;
  bool _startOn = false;
  int _index = 0;
  List _messages = [''];

  @override
  void initState() {
    super.initState();
    _updateDate();
    _animationController = AnimationController(
      duration: TerminalAnimation.kSuggestedDuration,
      vsync: this,
    )..addStatusListener(_onAnimationStatus);
    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // will trigger this method whenever the theme changes
    _colors = ColorThemes.colorsFor(Theme.of(context).brightness);
    _updateTextStyles(_colors);
  }

  @override
  void didUpdateWidget(Terminal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ideograph != oldWidget.ideograph ||
        widget.text != oldWidget.text) {
      _updateDisplayText();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
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

  void _updateTextStyles(final Map colors) {
    setState(() {
      _ideographStyle = TextStyle(
        fontFamily: 'YOzREFM',
        fontSize: 18.0,
        textBaseline: TextBaseline.ideographic,
        color: colors[ColorElement.tty_text],
        shadows: [],
      );
      _textStyle = TextStyle(
        fontFamily: 'CourierPrimeCodeItalic',
        fontSize: 16.0,
        height: 1.2,
        color: colors[ColorElement.tty_text],
        shadows: [],
      );
      _cursorStyle = TextStyle(
        fontFamily: 'DejaVuSansMono',
        fontSize: 16.0,
        height: 1.0,
        color: colors[ColorElement.tty_text],
        shadows: [],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final opacity = _colors == ColorThemes.light ? 0.94 : 0.7;
    return Semantics(
      label: 'date and weather',
      value: _date + '...${widget.semanticValue}',
      container: true,
      excludeSemantics: true,
      child: Container(
        constraints: BoxConstraints.expand(
          height: _textStyle.fontSize * 1.2 + 6.0,
        ),
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        decoration: BoxDecoration(
          color: _colors[ColorElement.tty_background].withOpacity(opacity),
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            SolidBoxShadow(
              blurRadius: 4,
              color: _colors[ColorElement.shadow].withOpacity(0.8),
              offset: Offset(0.5, 2),
            ),
          ],
        ),
        alignment: Alignment.bottomCenter,
        child: TerminalAnimation(
          ideograph: _index > 0 ? widget.ideograph : null,
          ideographStyle: _ideographStyle,
          startCursorOn: _startOn,
          message: _messages[_index],
          messageStyle: _textStyle,
          cursorStyle: _cursorStyle,
          controller: _animationController,
        ),
      ),
    );
  }
}
