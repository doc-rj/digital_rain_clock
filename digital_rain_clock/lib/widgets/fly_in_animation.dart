import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FlyInAnimation extends StatelessWidget {
  FlyInAnimation({
    Key key,
    @required this.child,
    @required this.controller,
  })  : assert(child != null),
        assert(controller != null),
        position = Tween<Offset>(
          begin: const Offset(0.0, -0.8),
          end: const Offset(0.0, -0.06),
        ).animate(
            CurvedAnimation(parent: controller, curve: Curves.linearToEaseOut)),
        scale = Tween<double>(
          begin: 0.2,
          end: 0.9,
        ).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInCubic)),
        rotation = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInCubic)),
        super(key: key);

  final Widget child;
  final Animation<double> controller;
  final Animation<Offset> position;
  final Animation<double> scale;
  final Animation<double> rotation;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: position,
      child: AnimatedBuilder(
        child: child,
        builder: _buildAnimation,
        animation: controller,
      ),
    );
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Transform(
      transform: Matrix4.identity()
        ..setRotationX(-1.5 * pi)
        ..rotateX(rotation.value * 0.75 * pi)
        ..scale(scale.value, scale.value),
      alignment: FractionalOffset.center,
      child: child,
    );
  }
}
