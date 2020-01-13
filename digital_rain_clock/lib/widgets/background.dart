import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

import '../themes.dart';

class Background extends StatefulWidget {
  const Background({Key key, @required this.model, @required this.colors})
      : super(key: key);
  final ClockModel model;
  final Map colors;

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background>
    with SingleTickerProviderStateMixin {
  Map _colors;
  bool _searchlight;
  AnimationController _animationController;
  Animation _gradientStop;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _gradientStop = Tween<double>(begin: -1.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
    widget.model.addListener(_onModelChanged);
  }

  @override
  void didChangeDependencies() {
    _updateColors();
  }

  @override
  void didUpdateWidget(Background oldWidget) {
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
    _updateColors();
  }

  /// requires build context
  void _updateColors() {
    final brightness = Theme.of(context).brightness;
    _colors =
        brightness == Brightness.light ? ColorThemes.light : ColorThemes.dark;
    _updateSearchlight();
  }

  void _updateSearchlight() {
    bool searchlight = _colors == ColorThemes.dark ||
        widget.model.weatherCondition == WeatherCondition.foggy ||
        widget.model.weatherCondition == WeatherCondition.thunderstorm;
    if (searchlight != _searchlight) {
      _searchlight = searchlight;
      _animationController.repeat(
          reverse: searchlight,
          period: Duration(seconds: searchlight ? 12 : 20)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget child) => _buildAnimation()),
    );
  }

  Widget _buildAnimation() {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: SweepGradient(
          center: Alignment.topLeft,
          stops: [
            0.0,
            _gradientStop.value,
            _gradientStop.value + (_searchlight ? 0.2 : 0.6),
          ],
          colors: [
            ColorThemes.background(_colors, widget.model.weatherCondition),
            _colors[ColorElement.highlight],
            ColorThemes.background(_colors, widget.model.weatherCondition),
          ],
        ),
      ),
    );
  }
}
