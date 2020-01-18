// Copyright 2019 Ryan Jones. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'background.dart';
import 'digital_rain.dart';
import 'foreground.dart';

class DigitalRainClock extends StatelessWidget {
  const DigitalRainClock({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Background(),
        DigitalRain(),
        Foreground(),
      ],
    );
  }
}
