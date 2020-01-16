import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'char_stream.dart';

class DigitalRain extends StatelessWidget {
  const DigitalRain({Key key, @required this.model, @required this.colors})
      : super(key: key);
  final ClockModel model;
  final Map colors;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return _buildContainer(context, constraints);
        },
      ),
    );
  }

  Widget _buildContainer(BuildContext context, BoxConstraints constraints) {
    return RotatedBox(
      quarterTurns: model.weatherCondition == WeatherCondition.windy ? 3 : 0,
      child: Row(
        children: <Widget>[
          ..._buildRain(context, constraints),
        ],
      ),
    );
  }

  List<Widget> _buildRain(BuildContext context, BoxConstraints constraints) {
    // fill the space per parent constraints, but limit the number of streams
    // due to performance considerations
    final streamWidth = CharStream.kMaxSize * 2;
    final mainAxisSize = model.weatherCondition == WeatherCondition.windy
        ? constraints.maxWidth
        : constraints.maxHeight;
    final crossAxisSize = model.weatherCondition == WeatherCondition.windy
        ? constraints.maxHeight
        : constraints.maxWidth;
    final numStreams = crossAxisSize ~/ streamWidth;
    return List<Expanded>.generate(
      numStreams,
      (_) => Expanded(
        child: CharStream(
            axisSize: mainAxisSize,
            height: constraints.maxHeight,
            model: model,
            colors: colors,
        ),
      ),
    );
  }
}
