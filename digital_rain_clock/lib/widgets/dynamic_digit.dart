import 'package:flutter/material.dart';
import 'fly_in_animation.dart';

class DynamicDigit extends StatefulWidget {
  const DynamicDigit(
    this.digit, {
    Key key,
    this.duration = const Duration(milliseconds: 500),
  })  : assert(digit != null),
        assert(duration != null),
        super(key: key);

  final int digit;
  final Duration duration;

  @override
  _DynamicDigitState createState() => _DynamicDigitState();
}

class _DynamicDigitState extends State<DynamicDigit>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();
  }

  @override
  void didUpdateWidget(DynamicDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digit != widget.digit) {
      _animationController.duration = widget.duration;
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlyInAnimation(
      child: Text(widget.digit.toString()),
      controller: _animationController,
    );
  }
}
