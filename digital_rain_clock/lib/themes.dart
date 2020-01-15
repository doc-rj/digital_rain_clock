import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

enum ColorElement {
  background,
  highlight,
  digit,
  shadow,
  lead_char,
  trail_char,
  char_shadow,
  tty_background,
  tty_text,
  sunny,
  rainy,
  cloudy,
  stormy,
  snowy,
  windy,
}

class ColorThemes {
  static const light = {
    ColorElement.background: Color(0xfff8f8f8),
    ColorElement.highlight: Colors.white,
    ColorElement.digit: Colors.black,
    ColorElement.shadow: Color(0xff009a22),
    ColorElement.lead_char: Colors.black,
    ColorElement.trail_char: Colors.black,
    ColorElement.char_shadow: Color(0xfff8f8f8),
    ColorElement.tty_background: Colors.white,
    ColorElement.tty_text: Colors.black,
    ColorElement.sunny: Color(0xffe7f5fe),
    ColorElement.rainy: Color(0xffecffed),
    ColorElement.cloudy: Color(0xfff2f3f4),
    ColorElement.stormy: Color(0xffe5e4e2),
    ColorElement.snowy: Colors.white,
    ColorElement.windy: Color(0xfff2f2fc),
  };

  static const dark = {
    ColorElement.background: Colors.black,
    ColorElement.highlight: Colors.black38,
    ColorElement.digit: Colors.white,
    ColorElement.shadow: Color(0xff009a22),
    ColorElement.lead_char: Colors.white,
    ColorElement.trail_char: Color(0xff00ff41),
    ColorElement.char_shadow: Colors.black,
    ColorElement.tty_background: Colors.black,
    ColorElement.tty_text: Colors.white,
  };

  static const conditions = {
    WeatherCondition.sunny: ColorElement.sunny,
    WeatherCondition.rainy: ColorElement.rainy,
    WeatherCondition.cloudy: ColorElement.cloudy,
    WeatherCondition.foggy: ColorElement.stormy,
    WeatherCondition.thunderstorm: ColorElement.stormy,
    WeatherCondition.snowy: ColorElement.snowy,
    WeatherCondition.windy: ColorElement.windy,
  };

  static Color background(Map colors, WeatherCondition condition,
      {Color defaultColor = null}) {
    final defaultBg = defaultColor ?? colors[ColorElement.background];
    ColorElement colorKey = conditions[condition];
    return colorKey != null ? colors[colorKey] ?? defaultBg : defaultBg;
  }
}
