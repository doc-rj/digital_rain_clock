import 'dart:async';
import 'package:flutter/material.dart';
import '../themes.dart';
import 'char.dart';

class DynamicDigit extends StatefulWidget {
  const DynamicDigit(
    this.digit, {
    Key key,
    @required this.colors,
    this.period = 150,
    this.numPeriods = 2,
  }) : super(key: key);

  final int digit;
  final Map colors;
  final int period;
  final int numPeriods;

  @override
  _DynamicDigitState createState() => _DynamicDigitState();
}

class _DynamicDigitState extends State<DynamicDigit>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Widget _child;
  Timer _timer;
  int _periodsLeft;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0.2,
      upperBound: 1.0,
      duration: Duration(milliseconds: widget.period * widget.numPeriods),
    );
    _animationController.forward();
    _updatePeriodsLeft();
  }

  @override
  void didUpdateWidget(DynamicDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digit != widget.digit) {
      _updatePeriodsLeft();
      _animationController.forward(from: 0.2);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _updatePeriodsLeft() {
    _periodsLeft = widget.numPeriods;
    _updateDigit();
  }

  void _updateDigit() {
    setState(() {
      if (_periodsLeft-- > 0) {
        _child = Char(
          fontSize: 60.0,
          color: widget.colors[ColorElement.digit],
          opacity: 0.7,
          colors: widget.colors,
        );
        _timer = Timer(
          Duration(milliseconds: widget.period),
          _updateDigit,
        );
      } else {
        _child = Text(widget.digit.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animationController,
      child: _child,
    );
  }
}
