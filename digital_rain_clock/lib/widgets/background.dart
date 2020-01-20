import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:provider/provider.dart';
import '../themes.dart';

class Background extends StatefulWidget {
  const Background({Key key}) : super(key: key);

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background>
    with SingleTickerProviderStateMixin {
  Map _colors;
  bool _searchlight;
  WeatherCondition _weatherCondition;
  AnimationController _animationController;
  Animation _gradientStop;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _gradientStop = Tween<double>(begin: -1.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // will trigger this method whenever the model changes
    final model = Provider.of<ClockModel>(context, listen: true);
    _weatherCondition = model.weatherCondition;
    // will trigger this method whenever the theme changes
    final brightness = Theme.of(context).brightness;
    _colors =
        brightness == Brightness.light ? ColorThemes.light : ColorThemes.dark;
    _updateSearchlight(_colors);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// simulates a roving searchlight/spotlight in darker conditions;
  /// this updates the animation when the mode changes to/from "searchlight"
  void _updateSearchlight(final Map colors) {
    bool searchlight = colors == ColorThemes.dark ||
        _weatherCondition == WeatherCondition.foggy ||
        _weatherCondition == WeatherCondition.thunderstorm;
    if (searchlight != _searchlight) {
      _searchlight = searchlight;
      _animationController.repeat(
          reverse: searchlight,
          period: Duration(seconds: searchlight ? 12 : 20));
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
            ColorThemes.background(_colors, _weatherCondition),
            _colors[ColorElement.highlight],
            ColorThemes.background(_colors, _weatherCondition),
          ],
        ),
      ),
    );
  }
}
