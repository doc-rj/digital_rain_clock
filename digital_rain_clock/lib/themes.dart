import 'package:flutter/material.dart';

enum ColorElement {
  background,
  digit,
  shadow,
  lead_char,
  trail_char,
  char_shadow,
  tty_background,
  tty_text,
}

class ColorThemes {
  static const lightTheme = {
    ColorElement.background: Color(0xfff8f8f8),
    ColorElement.digit: Colors.black,
    ColorElement.shadow: Color(0xff009a22),
    ColorElement.lead_char: Colors.black,
    ColorElement.trail_char: Colors.black,
    ColorElement.char_shadow: Color(0xfff8f8f8),
    ColorElement.tty_background: Color(0xfffcfcfc),
    ColorElement.tty_text: Colors.black,
  };

  static const darkTheme = {
    ColorElement.background: Colors.black,
    ColorElement.digit: Colors.white,
    ColorElement.shadow: Color(0xff009a22),
    ColorElement.lead_char: Colors.white,
    ColorElement.trail_char: Color(0xff00ff41),
    ColorElement.char_shadow: Colors.black,
    ColorElement.tty_background: Colors.black,
    ColorElement.tty_text: Colors.white,
  };
}
