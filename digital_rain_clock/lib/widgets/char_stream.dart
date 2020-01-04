import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import '../themes.dart';
import 'dynamic_char.dart';
import 'char.dart';

class CharStream extends StatefulWidget {
  const CharStream({@required this.height, @required this.colors});
  final double height;
  final Map colors;

  static const minSize = 16;
  static const maxSize = 18;
  static const minTrailChars = 12;
  static const maxTrailChars = 32;

  @override
  _CharStreamState createState() => _CharStreamState();
}

class _CharStreamState extends State<CharStream>
    with SingleTickerProviderStateMixin {
  final _random = Random();

  bool _streamed = false;
  List<Widget> _chars = <Widget>[];
  AnimationController _animationController;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: -1.0,
      upperBound: 1.0,
    );
    _stream();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _stream() async {
    final fontSize =
        _nextRandom(CharStream.minSize, CharStream.maxSize).toDouble();
    final scaleRatio = fontSize / CharStream.maxSize;
    final duration = (_nextRandom(5, 7) / scaleRatio).floor();
    // eager build before delay
    _chars = <Widget>[
      ..._buildTrailChars(fontSize),
      ..._buildLeadChars(fontSize),
    ];
    // initial delay for dramatic effect and to minimize jank
    if (!_streamed) {
      await Future.delayed(Duration(seconds: 7));
    }
    // random delay followed by stream
    Future.delayed(Duration(seconds: _nextRandom(1, 8)), () {
      _streamed = true;
      _animationController.duration = Duration(seconds: duration);
      _animationController.reset();
      _animationController.forward();
      // todo: consider listening for status instead
      _timer = Timer(
        Duration(seconds: duration),
        _stream,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      // not providing child, because we want to use rebuilt _chars
      builder: (BuildContext context, Widget child) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(0.0, _animationController.value * widget.height, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _chars,
          ),
        );
      },
    );
  }

  List<Flexible> _buildTrailChars(double fontSize) {
    final numChars =
        _nextRandom(CharStream.minTrailChars, CharStream.maxTrailChars);
    return List<Flexible>.generate(numChars, (int index) {
      final position = numChars - index;
      return Flexible(
          child: position % 5 == 0
              ? DynamicChar(
                  fontSize: fontSize,
                  color: widget.colors[ColorElement.trail_char],
                  colors: widget.colors,
                  opacity: _computeTrailOpacity(index),
                  period: 1000,
                )
              : Char(
                  fontSize: fontSize,
                  color: widget.colors[ColorElement.trail_char],
                  colors: widget.colors,
                  opacity: _computeTrailOpacity(index),
                ));
    });
  }

  List<Flexible> _buildLeadChars(double fontSize) {
    final numChars = 3;
    return List<Flexible>.generate(numChars, (int index) {
      return _buildLeadChar(index, numChars, fontSize);
    });
  }

  Flexible _buildLeadChar(int index, int numChars, double fontSize) {
    final position = numChars - index;
    return Flexible(
        child: DynamicChar(
      fontSize: fontSize,
      color: widget.colors[ColorElement.lead_char],
      colors: widget.colors,
      opacity: _computeLeadOpacity(index),
      period: position == 1 ? 300 : 1000,
    ));
  }

  double _computeLeadOpacity(int index) {
    switch (index) {
      case 0:
        return 0.6;
      case 1:
        return 0.7;
      case 2:
        return 0.9;
      default:
        return 0.5;
    }
  }

  double _computeTrailOpacity(int index) {
    switch (index) {
      case 0:
        return 0.1;
      case 1:
      case 2:
        return 0.2;
      case 3:
      case 4:
        return 0.3;
      case 5:
      case 6:
        return 0.4;
      default:
        return 0.6;
    }
  }

  int _nextRandom(int min, int max) => min + _random.nextInt(max - min);
}
