import 'dart:async';
import 'package:flutter/material.dart';
import '../themes.dart';
import 'char.dart';

class DynamicDigit extends StatefulWidget {
  const DynamicDigit({
    @required this.child,
    @required this.colors,
    this.period = 200,
    this.numPeriods = 2,
  });

  final Text child;
  final Map colors;
  final int period;
  final int numPeriods;

  @override
  _DynamicDigitState createState() => _DynamicDigitState();
}

class _DynamicDigitState extends State<DynamicDigit>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Widget _digit;
  Timer _timer;
  int _periodsLeft;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this,
        lowerBound: 0.2,
        upperBound: 1.0,
        duration: Duration(milliseconds: widget.period * widget.numPeriods));

    _animationController.forward();
    _periodsLeft = widget.numPeriods;
    _updateDigit();
  }

  @override
  void didUpdateWidget(DynamicDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child.data != widget.child.data) {
      _periodsLeft = widget.numPeriods;
      _updateDigit();
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _updateDigit() {
    setState(() {
      if (_periodsLeft-- > 0) {
        _digit = Char(
          fontSize: 100.0,
          color: widget.colors[ColorElement.digit],
          colors: widget.colors,
        );
        _timer = Timer(
          Duration(milliseconds: widget.period),
          _updateDigit,
        );
      } else {
        _digit = widget.child;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animationController,
      child: _digit,
    );
  }
}
