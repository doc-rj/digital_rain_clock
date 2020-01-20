import 'package:flutter/material.dart';

class Switcher extends StatelessWidget {
  const Switcher({Key key, this.child})
      : assert(child != null),
        super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeOut,
      child: child,
    );
  }
}
