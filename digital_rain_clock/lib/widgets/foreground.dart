import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:provider/provider.dart';

import 'time.dart';
import 'terminal.dart';

class Foreground extends StatelessWidget {
  const Foreground({Key key}) : super(key: key);

  static const ideograph = {
    WeatherCondition.sunny: '\u{263c}',
    WeatherCondition.cloudy: '\u{2601}',
    WeatherCondition.foggy: '\u{2601}',
    WeatherCondition.rainy: '\u{2602}',
    WeatherCondition.thunderstorm: '\u{2602}',
    WeatherCondition.snowy: '\u{2746}',
    WeatherCondition.windy: '\u{2652}'
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Consumer<ClockModel>(
          builder: (context, model, child) => Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Time(is24HourFormat: model.is24HourFormat),
              Terminal(
                ideograph: ideograph[model.weatherCondition],
                text: _message(model),
                semanticValue: _semanticMessage(model),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _message(ClockModel model) {
    return _capitalize(model.weatherString) +
        ' ${_temperatureString(model.temperature)}' +
        '\u{2005}\u{25b2}${_temperatureString(model.high)}' +
        '\u{2005}\u{25bc}${_temperatureString(model.low)}';
  }

  String _semanticMessage(ClockModel model) {
    return 'The weather is: ${model.weatherString}.' +
        'The temperature is ${_temperatureString(model.temperature)}' +
        ', with a high of ${_temperatureString(model.high)}' +
        ' and a low of ${_temperatureString(model.low)}.';
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  String _temperatureString(num temperature) {
    return '${temperature.round()}°';
  }
}
