import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'char_stream.dart';

class DigitalRain extends StatelessWidget {
  const DigitalRain({Key key, @required this.model, @required this.colors})
      : super(key: key);
  final ClockModel model;
  final Map colors;

  /// This multiplier controls digital rain stream width, and it's multiplied
  /// by the max char fontSize to compute said width. The greater the width, the
  /// smaller the number of streams, and vice-versa. Beware, as too many char
  /// streams may push the UI and GPU threads past their jank-free limits,
  /// depending on the host device. Use with caution.
  ///
  /// A multiplier of 0.66 will fill the width of the screen packed wall-to-wall
  /// with streams, but with potentially many dropped frames; in some profile
  /// mode testing, I found a multiplier of 2.0 to be a fair compromise between
  /// good looks and performance.
  static const kStreamWidthMultiplier = 2.0;

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
    // filling the space per parent constraints, but limiting the number of
    // streams due to performance considerations
    final streamWidth = CharStream.kMaxSize * kStreamWidthMultiplier;
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
