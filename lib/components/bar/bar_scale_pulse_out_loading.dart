import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

import 'bar.dart';

class BarScalePulseOutLoading extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final BorderRadiusGeometry borderRadius;
  final Duration duration;
  final Curve curve;
  final int barCount;

  const BarScalePulseOutLoading({
    Key? key,
    this.width = 3.5,
    this.height = 18.0,
    this.color = const Color.fromARGB(255, 215, 107, 243),
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(3),
      topRight: Radius.circular(3),
      bottomLeft: Radius.circular(3),
      bottomRight: Radius.circular(3),
    ),
    this.barCount = 5,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.decelerate,
  }) : super(key: key);

  @override
  _BarScalePulseOutLoadingState createState() => _BarScalePulseOutLoadingState();
}

class _BarScalePulseOutLoadingState extends State<BarScalePulseOutLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;
  final Random _random = Random();

  double _maxScale = 2.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();

    _animations = List.generate(widget.barCount, (_) => _createRandomAnimation());
  }

  Animation<double> _createRandomAnimation() {
    final begin = _random.nextDouble() * 0.5;
    final end = begin + 0.5;
    return TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: _maxScale), weight: 50),
      TweenSequenceItem(tween: Tween(begin: _maxScale, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(begin, end, curve: widget.curve),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(widget.barCount, (index) {
            return _item(_animations[index]);
          }),
        );
      },
    );
  }

  Widget _item(Animation<double> animation) {
    return Transform(
      transform: Matrix4.identity()..scale(1.0, animation.value, 1.0),
      alignment: Alignment.center,
      child: Bar(
        color: widget.color,
        width: widget.width,
        borderRadius: widget.borderRadius,
        height: widget.height,
      ),
    );
  }
}