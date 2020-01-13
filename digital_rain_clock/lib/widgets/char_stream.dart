import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

import '../themes.dart';
import 'dynamic_char.dart';
import 'char.dart';

class CharStream extends StatefulWidget {
  const CharStream({
    Key key,
    @required this.height,
    @required this.model,
    @required this.colors,
  }) : super(key: key);

  final double height;
  final ClockModel model;
  final Map colors;

  static const kMinSize = 16;
  static const kMaxSize = 19;
  static const kScaleMultiplier = 1 / kMaxSize;

  static const kMinDuration = 5;
  static const kMaxDuration = 10;
  static const kMinDurationFast = 3;
  static const kMaxDurationFast = 6;

  @override
  _CharStreamState createState() => _CharStreamState();
}

class _CharStreamState extends State<CharStream>
    with SingleTickerProviderStateMixin {
  final _random = Random();

  bool _fast = false;
  bool _streamed = false;
  List<Widget> _chars = <Widget>[];
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _updateConditions();
    widget.model.addListener(_onModelChanged);
    _animationController = AnimationController(
      vsync: this,
      lowerBound: -1.0,
      upperBound: 1.0,
    );
    _animationController.addStatusListener(_onAnimationStatus);
    _stream();
  }

  @override
  void didUpdateWidget(CharStream oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_onModelChanged);
      widget.model.addListener(_onModelChanged);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.model.removeListener(_onModelChanged);
    super.dispose();
  }

  void _onModelChanged() {
    _updateConditions();
  }

  void _updateConditions() {
    // no setState() here, as the next stream will catch up
    _fast = widget.model.weatherCondition == WeatherCondition.thunderstorm;
  }

  Future<void> _onAnimationStatus(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      _stream();
    }
  }

  Future<void> _stream() async {
    final fontSize =
        _nextRandom(CharStream.kMinSize, CharStream.kMaxSize).toDouble();
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
      if (mounted) {
        _streamed = true;
        _animationController.duration = Duration(seconds: _duration(fontSize));
        _animationController.forward(from: -1.0);
      }
    });
  }

  int _duration(double fontSize) {
    final scaleRatio = fontSize * CharStream.kScaleMultiplier;
    return _nextRandom(minDuration, maxDuration) ~/ scaleRatio;
  }

  int get minDuration =>
      _fast ? CharStream.kMinDurationFast : CharStream.kMinDuration;

  int get maxDuration =>
      _fast ? CharStream.kMaxDurationFast : CharStream.kMaxDuration;

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
    final maxTrailChars = (widget.height / fontSize).ceil();
    final minTrailChars = (maxTrailChars * 0.66).ceil();
    final numChars = _nextRandom(minTrailChars, maxTrailChars);
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
        return 0.6;
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
