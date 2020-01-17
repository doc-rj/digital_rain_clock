import 'dart:async';
import 'package:flutter/material.dart';
import 'char.dart';

class DynamicChar extends StatefulWidget {
  const DynamicChar(
      {Key key,
      @required this.fontSize,
      @required this.color,
      @required this.shadowColor,
      this.opacity = 1.0,
      this.period = 1000})
      : assert(fontSize != null),
        assert(color != null),
        assert(shadowColor != null),
        assert(opacity != null),
        assert(period != null),
        super(key: key);

  final double fontSize;
  final Color color;
  final Color shadowColor;
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
        shadowColor: widget.shadowColor,
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
