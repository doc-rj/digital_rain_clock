import 'dart:async';
import 'package:flutter/material.dart';
import 'char.dart';

class DynamicChar extends StatefulWidget {
  const DynamicChar({
    Key key,
    @required this.fontSize,
    @required this.color,
    @required this.colors,
    this.opacity = 1.0,
    this.period = 1000
  }) : super(key: key);

  final double fontSize;
  final Color color;
  final Map colors;
  final double opacity;
  final int period;

  @override
  _DynamicCharState createState() => _DynamicCharState();
}

class _DynamicCharState extends State<DynamicChar> {
  Widget _char;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateChar();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateChar() {
    setState(() {
      _char = Char(
          fontSize: widget.fontSize,
          color: widget.color,
          colors: widget.colors,
          opacity: widget.opacity,
      );
      _timer = Timer(
        Duration(milliseconds: widget.period),
        _updateChar,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _char;
  }
}
