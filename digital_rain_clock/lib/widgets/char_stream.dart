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
    @required this.axisSize,
    @required this.height,
    @required this.model,
    @required this.colors,
  }) : super(key: key);

  final double axisSize;
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

  static const kLeadCharOpacity = {
    0: 0.6,
    1: 0.7,
    2: 0.9,
  };

  static const kTrailCharOpacity = {
    0: 0.1,
    1: 0.2,
    2: 0.2,
    3: 0.3,
    4: 0.3,
    5: 0.4,
    6: 0.4,
  };

  @override
  _CharStreamState createState() => _CharStreamState();
}

class _CharStreamState extends State<CharStream>
    with SingleTickerProviderStateMixin {
  final _random = Random();

  bool _fast = false;
  bool _streamed = false;
  Alignment _alignment = Alignment.center;
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
    // one-time delay for dramatic effect, and to minimize loading jank
    if (!_streamed) {
      await Future.delayed(Duration(seconds: 5));
    }
    // random delay followed by stream
    Future.delayed(Duration(seconds: _nextRandom(1, 8)), () {
      if (mounted) {
        _streamed = true;
        _alignment = Alignment(_nextRandom(-1, 1).toDouble(), 0.0);
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
    return Container(
      alignment: _alignment,
      child: AnimatedBuilder(
        animation: _animationController,
        // not providing child, because we want to use rebuilt _chars
        builder: (BuildContext context, Widget child) {
          return Transform.translate(
            offset: Offset(0, _animationController.value * widget.axisSize),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _chars,
            ),
          );
        },
      ),
    );
  }

  List<Flexible> _buildTrailChars(double fontSize) {
    // using parent height constraint here so chars don't become temporarily
    // distorted when switching from windy to other conditions
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
                opacity: CharStream.kTrailCharOpacity[index] ?? 0.6,
                period: 1000,
              )
            : Char(
                fontSize: fontSize,
                color: widget.colors[ColorElement.trail_char],
                colors: widget.colors,
                opacity: CharStream.kTrailCharOpacity[index] ?? 0.6,
              ),
      );
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
      opacity: CharStream.kLeadCharOpacity[index] ?? 0.6,
      period: position == 1 ? 300 : 1000,
    ));
  }

  int _nextRandom(int min, int max) => min + _random.nextInt(max - min);
}
