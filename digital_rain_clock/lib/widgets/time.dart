import 'dart:async';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dynamic_digit.dart';

class Time extends StatefulWidget {
  const Time({@required this.model, @required this.colors});

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
              child: DynamicDigit(
                child: Text((_hour ~/ 10).toString()),
                colors: widget.colors,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: DynamicDigit(
                child: Text((_hour % 10).toString()),
                colors: widget.colors,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                ':',
                style: TextStyle(
                  fontSize: 50.0,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: DynamicDigit(
                child: Text((_minute ~/ 10).toString()),
                colors: widget.colors,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: DynamicDigit(
                child: Text((_minute % 10).toString()),
                colors: widget.colors,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                ':',
                style: TextStyle(
                  fontSize: 50.0,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: DynamicDigit(
                child: Text((_second ~/ 10).toString()),
                colors: widget.colors,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: DynamicDigit(
                child: Text((_second % 10).toString()),
                colors: widget.colors,
              ),
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

  /// slightly more efficient than DateFormat format with 'hh'
  int _24to12hour(int hour) {
    final period = hour < 12 ? DayPeriod.am : DayPeriod.pm;
    final offset = period == DayPeriod.am ? 0 : 12;
    return hour - offset;
  }
}
