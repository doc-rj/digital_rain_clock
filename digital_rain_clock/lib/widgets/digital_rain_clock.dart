// Copyright 2019 Ryan Jones. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';

import '../themes.dart';
import '../solid_shadow.dart';
import 'terminal.dart';
import 'digital_rain.dart';
import 'time.dart';

class DigitalRainClock extends StatefulWidget {
  const DigitalRainClock({@required this.model});
  final ClockModel model;

  static const ideograph = {
    WeatherCondition.sunny: '\u{2600}',
    WeatherCondition.cloudy: '\u{2601}',
    WeatherCondition.foggy: '\u{2601}',
    WeatherCondition.rainy: '\u{2602}',
    WeatherCondition.thunderstorm: '\u{2602}',
    WeatherCondition.snowy: '\u{2746}',
    WeatherCondition.windy: '\u{2652}'
  };

  @override
  _DigitalRainClockState createState() => _DigitalRainClockState();
}

class _DigitalRainClockState extends State<DigitalRainClock> {
  String _ideograph;
  String _message;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalRainClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _ideograph = DigitalRainClock.ideograph[widget.model.weatherCondition];
      _message = _capitalize(widget.model.weatherString) +
          " ${_temperatureString(widget.model.temperature)}" +
          "\u{2005}\u{25b2}${_temperatureString(widget.model.high)}" +
          "\u{2005}\u{25bc}${_temperatureString(widget.model.low)}";
    });
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  String _temperatureString(num temperature) {
    return '${temperature.round()}°';
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.light
        ? ColorThemes.lightTheme
        : ColorThemes.darkTheme;
    final defaultStyle = TextStyle(
      color: colors[ColorElement.digit]
          .withOpacity(brightness == Brightness.light ? 0.7 : 0.9),
      fontFamily: 'OCRA',
      fontSize: MediaQuery.of(context).size.width / 6,
      shadows: [
        SolidShadow(
          blurRadius: 3,
          color: colors[ColorElement.shadow].withOpacity(0.8),
          offset: Offset(3, 3),
        ),
      ],
    );
    return Container(
      color: colors[ColorElement.background],
      child: DefaultTextStyle(
        style: defaultStyle,
        child: Stack(
          children: <Widget>[
            DigitalRain(model: widget.model, colors: colors),
            _buildForeground(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildForeground(final Map colors) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.85,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Time(model: widget.model, colors: colors),
            Terminal(
              ideograph: _ideograph,
              text: _message,
              colors: colors,
            ),
          ],
        ),
      ),
    );
  }
}
