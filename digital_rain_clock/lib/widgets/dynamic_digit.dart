import 'dart:math';
import 'package:flutter/material.dart';

class DynamicDigit extends StatefulWidget {
  const DynamicDigit(
    this.digit, {
    Key key,
    this.duration = 500,
  }) : super(key: key);

  final int digit;
  final int duration;

  static final scaleTween = Tween<double>(
    begin: 0.2,
    end: 0.9,
  );
  static final slideTween = Tween<Offset>(
    begin: const Offset(0.0, -0.8),
    end: const Offset(0.0, -0.06),
  );
  static final rotateTween = Tween<double>(
    begin: 1.0,
    end: 0.0,
  );

  @override
  _DynamicDigitState createState() => _DynamicDigitState();
}

class _DynamicDigitState extends State<DynamicDigit>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _slideAnimation;
  Animation<double> _scaleAnimation;
  Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );

    _slideAnimation = DynamicDigit.slideTween.animate(CurvedAnimation(
        parent: _animationController, curve: Curves.linearToEaseOut));
    _scaleAnimation = DynamicDigit.scaleTween.animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCubic));
    _rotateAnimation = DynamicDigit.rotateTween.animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCubic));
    _animationController.forward();
  }

  @override
  void didUpdateWidget(DynamicDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digit != widget.digit) {
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
    return SlideTransition(
      position: _slideAnimation,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget child) {
          return Transform(
            transform: Matrix4.identity()
              ..setRotationX(-1.5 * pi)
              ..rotateX(_rotateAnimation.value * 0.75 * pi)
              ..scale(_scaleAnimation.value, _scaleAnimation.value),
            alignment: FractionalOffset.center,
            child: Text(widget.digit.toString()),
          );
        },
      ),
    );
  }
}
