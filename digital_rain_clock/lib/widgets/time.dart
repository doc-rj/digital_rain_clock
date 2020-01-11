import 'dart:async';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dynamic_digit.dart';
import 'animated_digit.dart';

enum Unit { hours, minutes, seconds }
enum Place { tens, ones }

class Time extends StatefulWidget {
  const Time({Key key, @required this.model, @required this.colors})
      : super(key: key);

  final ClockModel model;
  final Map colors;

  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time> {
  int _hour;
  int _minute;
  int _second;
  String _semanticValue;
  Timer _timer;

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
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: time.millisecond),
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
    return _shouldDoDynamic(unit, place)
        ? DynamicDigit(digit, colors: widget.colors)
        : AnimatedDigit(digit);
  }

  bool _shouldDoDynamic(Unit unit, Place place) {
    switch (unit) {
      case Unit.hours:
        if (place == Place.tens) {
          return _hour % 12 == 0 && _minute == 0 && _second == 0;
        }
        // ones
        return _minute == 0 && _second == 0;

      case Unit.minutes:
        if (place == Place.tens) {
          return _minute % 10 == 0 && _second == 0;
        }
        // ones
        return _second == 0;

      case Unit.seconds:
        return _second % 10 == 0;
    }
  }

  /// slightly more efficient than DateFormat format with 'hh'
  int _24to12hour(int hour) {
    final period = hour < 12 ? DayPeriod.am : DayPeriod.pm;
    final offset = period == DayPeriod.am ? 0 : 12;
    return hour - offset;
  }
}
