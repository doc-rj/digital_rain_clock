import 'package:flutter/material.dart';

enum ColorElement {
  background,
  digit,
  shadow,
  lead_char,
  trail_char,
  char_shadow,
  crt_background,
  crt_text,
}

class ColorThemes {
  static const lightTheme = {
    ColorElement.background: Colors.white,
    ColorElement.digit: Colors.black,
    ColorElement.shadow: Color(0xff009a22),
    ColorElement.lead_char: Colors.black,
    ColorElement.trail_char: Colors.black,
    ColorElement.char_shadow: Colors.white,
    ColorElement.crt_background: Colors.black,
    ColorElement.crt_text: Color(0xffa6ffa6),
  };

  static const darkTheme = {
    ColorElement.background: Colors.black,
    ColorElement.digit: Colors.white,
    ColorElement.shadow: Color(0xff009a22),
    ColorElement.lead_char: Colors.white,
    ColorElement.trail_char: Color(0xff00ff41),
    ColorElement.char_shadow: Colors.black,
    ColorElement.crt_background: Colors.black,
    ColorElement.crt_text: Colors.white,
  };
}
