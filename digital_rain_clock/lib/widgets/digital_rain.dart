import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'char_stream.dart';
//import 'text_stream.dart';

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
              //_buildText(context, model.weatherString),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildRain(BuildContext context, BoxConstraints constraints) {
    // fill the width per parent constraints
    final streamWidth = CharStream.maxSize / 1.5;
    final numStreams = (constraints.maxWidth / streamWidth).floor();
    return List<Expanded>.generate(
        numStreams,
        (_) => Expanded(
            child: CharStream(height: constraints.maxHeight, colors: colors)));
  }

  // todo: remove
  //Widget _buildText(BuildContext context, String text) {
  //  return Expanded(child: TextStream(text: text, colors: colors));
  //}
}
