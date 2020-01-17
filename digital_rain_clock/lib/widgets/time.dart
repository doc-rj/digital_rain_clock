import 'dart:async';
import 'dart:math';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dynamic_digit.dart';
import 'digit_switcher.dart';

enum Unit { hours, minutes, seconds }
enum Place { tens, ones }

class Time extends StatefulWidget {
  const Time({Key key, @required this.model}) : super(key: key);

  final ClockModel model;

  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time> {
  int _hour;
  int _minute;
  int _second;

  DateTime _nextTime;
  bool _dynamic = false;

  String _semanticValue;
  Timer _timer;
  int _duration;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      DateTime time = DateTime.now();
      _hour = widget.model.is24HourFormat ? time.hour : _24to12hour(time.hour);
      _minute = time.minute;
      _second = time.second;
      _semanticValue = widget.model.is24HourFormat
          ? DateFormat.Hms().format(time)
          : DateFormat.jms().format(time);
      _nextTime = time.add(Duration(seconds: 1));
      _dynamic = _nextTime.minute % 15 == 0;
      final millisLeft = 1000 - time.millisecond;
      _duration = _dynamic ? max(500, millisLeft) : millisLeft;
      _timer = Timer(
        Duration(milliseconds: _duration),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'digital clock',
      value: _semanticValue,
      container: true,
      excludeSemantics: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Center(
              child: _digit(_hour, Unit.hours, Place.tens),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: _digit(_hour, Unit.hours, Place.ones),
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
              child: _digit(_minute, Unit.minutes, Place.tens),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: _digit(_minute, Unit.minutes, Place.ones),
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
              child: _digit(_second, Unit.seconds, Place.tens),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: _digit(_second, Unit.seconds, Place.ones),
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
    );
  }

  Widget _digit(int value, Unit unit, Place place) {
    final digit = place == Place.tens ? value ~/ 10 : value % 10;
    return _dynamic && _shouldDoDynamic(_nextTime, unit, place)
        ? DynamicDigit(digit, duration: _duration)
        : DigitSwitcher(digit);
  }

  /// per unit or digit decision whether to show special time change animation
  bool _shouldDoDynamic(DateTime nextTime, unit, Place place) {
    switch (unit) {
      case Unit.hours:
        return nextTime.minute == 0 && nextTime.second == 0;

      case Unit.minutes:
      case Unit.seconds:
        return nextTime.minute % 15 == 0 && nextTime.second == 0;
    }
  }

  /// slightly more efficient than DateFormat format with 'hh'
  int _24to12hour(int hour) {
    final period = hour < 12 ? DayPeriod.am : DayPeriod.pm;
    final offset = period == DayPeriod.am ? 0 : 12;
    return hour - offset;
  }
}
