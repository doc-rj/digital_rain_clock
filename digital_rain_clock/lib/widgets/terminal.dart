import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../themes.dart';
import '../solid_box_shadow.dart';
import 'terminal_animation.dart';

class Terminal extends StatefulWidget {
  const Terminal({@required this.text, @required this.colors});
  final String text;
  final Map colors;

  @override
  State createState() => new TerminalState();
}

class TerminalState extends State<Terminal> with TickerProviderStateMixin {
  TextStyle _textStyle;
  AnimationController _animationController;

  Timer _timer;
  String _date;
  bool _startOn = false;
  int _index = 0;
  List _displayText = [''];

  @override
  void initState() {
    super.initState();
    _updateDate();
    _updateTextStyle();
    _animationController = AnimationController(
      duration: TerminalAnimation.kDuration,
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
    if (widget.text != oldWidget.text) {
      _updateDisplayText();
    }
    if (widget.colors != oldWidget.colors) {
      _updateTextStyle();
    }
  }

  Future<void> _onAnimationStatus(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      await Future.delayed(Duration(milliseconds: 500));
      _animationController.reverse();
    } else if (status == AnimationStatus.dismissed) {
      setState(() {
        _startOn = !_startOn;
        //_index = _index == 0 ? 1 : 0;
        _index = _index == _displayText.length - 1 ? 0 : ++_index;
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
      _displayText.clear();
      _displayText.add(_date);
      _displayText.add(widget.text);
    });
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
    return Container(
      constraints: BoxConstraints.expand(
        height: _textStyle.fontSize * 1.2 + 6.0,
      ),
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
      alignment: Alignment.bottomCenter,
      child: TerminalAnimation(
        startCursorOn: _startOn,
        text: _displayText[_index],
        textStyle: _textStyle,
        colors: widget.colors,
        controller: _animationController,
      ),
    );
  }
}
