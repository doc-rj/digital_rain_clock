import 'package:flutter/material.dart';

class AnimatedDigit extends StatelessWidget {
  const AnimatedDigit(this.digit, {Key key}) : super(key: key);
  final int digit;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeOut,
      child: Text(
          digit.toString(),
          key: ValueKey<int>(digit),
      ),
    );
  }
}
