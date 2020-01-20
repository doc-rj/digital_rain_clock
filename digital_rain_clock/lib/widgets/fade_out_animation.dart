import 'package:flutter/material.dart';

class FadeOutAnimation extends StatelessWidget {
  FadeOutAnimation({
    Key key,
    @required this.child,
    @required this.controller,
  })  : assert(child != null),
        assert(controller != null),
        opacity = Tween<double>(
          begin: 1.0,
          end: 0.1,
        ).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInCubic)),
        super(key: key);

  final Widget child;
  final Animation<double> controller;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: child,
    );
  }
}
