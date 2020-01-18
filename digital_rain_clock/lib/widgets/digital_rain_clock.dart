// Copyright 2019 Ryan Jones. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import '../themes.dart';
import '../solid_shadow.dart';
import 'background.dart';
import 'foreground.dart';
import 'digital_rain.dart';

class DigitalRainClock extends StatelessWidget {
  const DigitalRainClock({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = ColorThemes.colorsFor(Theme.of(context).brightness);
    final defaultStyle = TextStyle(
      color: colors[ColorElement.digit]
          .withOpacity(colors == ColorThemes.light ? 0.7 : 0.9),
      fontFamily: 'OCRA',
      fontSize: MediaQuery.of(context).size.width / 6,
      shadows: [
        SolidShadow(
          blurRadius: 3,
          color: colors[ColorElement.shadow].withOpacity(0.8),
          offset: Offset(3, 3),
        ),
      ],
    );
    return DefaultTextStyle(
      style: defaultStyle,
      child: Stack(
        children: <Widget>[
          Background(),
          DigitalRain(),
          Foreground(),
        ],
      ),
    );
  }
}
