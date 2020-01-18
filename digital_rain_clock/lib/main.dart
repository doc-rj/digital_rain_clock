// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/digital_rain_clock.dart';

/// overrides for desktop platforms not supported by TargetPlatform
void _setTargetPlatformForDesktop() {
  if (!kIsWeb && (Platform.isLinux || Platform.isWindows)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _setTargetPlatformForDesktop();
  runApp(ClockCustomizer((ClockModel model) =>
      ChangeNotifierProvider.value(value: model, child: DigitalRainClock())));
}
