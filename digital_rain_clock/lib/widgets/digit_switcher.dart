import 'package:flutter/material.dart';

class DigitSwitcher extends StatelessWidget {
  const DigitSwitcher(this.digit, {Key key}) : super(key: key);
  final int digit;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeOut,
      child: Text(
          digit.toString(),
          key: ValueKey<int>(digit),
      ),
    );
  }
}
