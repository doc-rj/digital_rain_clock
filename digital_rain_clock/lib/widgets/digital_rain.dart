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
          return Row(
            children: <Widget>[
              ..._buildRain(context, constraints),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildRain(BuildContext context, BoxConstraints constraints) {
    // fill the width per parent constraints
    final streamWidth = CharStream.kMaxSize / 1.5;
    final numStreams = constraints.maxWidth ~/ streamWidth;
    return List<Expanded>.generate(
        numStreams,
        (_) => Expanded(
            child: CharStream(
                height: constraints.maxHeight, model: model, colors: colors)));
  }
}
