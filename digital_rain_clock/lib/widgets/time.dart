import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../themes.dart';
import '../solid_shadow.dart';
import 'switcher.dart';
import 'entry_exit.dart';

enum Mode { entry, exit, normal }
enum Place { tens, ones }

class Time extends StatefulWidget {
  const Time({Key key, this.is24HourFormat = false})
      : assert(is24HourFormat != null),
        super(key: key);

  final bool is24HourFormat;

  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time> {
  int _hour;
  int _minute;
  int _second;

  TextStyle _digitStyle;
  String _semanticValue;
  Duration _duration;
  Timer _timer;
  Mode _mode;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // will trigger this method whenever the theme changes
    final colors = ColorThemes.colorsFor(Theme.of(context).brightness);
    _digitStyle = TextStyle(
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
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      DateTime now = DateTime.now();
      _hour = widget.is24HourFormat ? now.hour : _from24to12hour(now.hour);
      _minute = now.minute;
      _second = now.second;
      _semanticValue = widget.is24HourFormat
          ? DateFormat.Hms().format(now)
          : DateFormat.jms().format(now);
      _mode = _computeMode(now);
      final millisLeft = 1000 - now.millisecond;
      _duration = Duration(
        milliseconds: _mode == Mode.entry ? max(500, millisLeft) : millisLeft,
      );
      _timer = Timer(_duration, _updateTime);
    });
  }

  /// every half hour, this causes an exit animation followed by an entry
  /// animation: exit on second 58, and entry on second 59
  Mode _computeMode(final DateTime time) {
    if (time.second < 58 || (time.minute + 1) % 30 > 0) {
      return Mode.normal;
    } else if (time.second == 58) {
      return Mode.exit;
    } else {
      // time.second == 59
      return Mode.entry;
    }
  }

  int _from24to12hour(int hour) {
    final period = hour < 12 ? DayPeriod.am : DayPeriod.pm;
    final offset = period == DayPeriod.am ? 0 : 12;
    return hour - offset;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'digital clock',
      value: _semanticValue,
      container: true,
      excludeSemantics: true,
      child: DefaultTextStyle(
        style: _digitStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Center(
                child: _digit(_hour, Place.tens),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: _digit(_hour, Place.ones),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                ':',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 44.0,
                  letterSpacing: 0.0,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: _digit(_minute, Place.tens),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: _digit(_minute, Place.ones),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                ':',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 44.0,
                  letterSpacing: 0.0,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: _digit(_second, Place.tens),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: _digit(_second, Place.ones),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(right: 1.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _digit(int value, Place place) {
    final digit = place == Place.tens ? value ~/ 10 : value % 10;
    final child = Text(digit.toString(), key: ValueKey<int>(digit));
    switch (_mode) {
      case Mode.entry:
        return EntryExit(child: child, duration: _duration, isEntry: true);
      case Mode.exit:
        return Switcher(
          child: EntryExit(child: child, duration: _duration, isEntry: false),
        );
      case Mode.normal:
      default:
        return Switcher(child: child);
    }
  }
}
