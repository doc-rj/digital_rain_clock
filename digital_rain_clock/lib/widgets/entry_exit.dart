import 'package:flutter/material.dart';
import 'fly_in_animation.dart';
import 'fade_out_animation.dart';

class EntryExit extends StatefulWidget {
  const EntryExit({
    Key key,
    @required this.child,
    @required this.isEntry,
    this.duration = const Duration(milliseconds: 500),
  })  : assert(child != null),
        assert(isEntry != null),
        assert(duration != null),
        super(key: key);

  final Widget child;
  final bool isEntry;
  final Duration duration;

  @override
  _EntryExitState createState() => _EntryExitState();
}

class _EntryExitState extends State<EntryExit> with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();
  }

  @override
  void didUpdateWidget(EntryExit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _animationController.duration = widget.duration;
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEntry) {
      return FlyInAnimation(
        child: widget.child,
        controller: _animationController,
      );
    } else {
      return FadeOutAnimation(
        child: widget.child,
        controller: _animationController,
      );
    }
  }
}
