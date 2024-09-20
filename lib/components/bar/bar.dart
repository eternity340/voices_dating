import 'package:flutter/material.dart';

class Bar extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final BorderRadiusGeometry borderRadius;

  const Bar({
    Key? key,
    required this.width,
    required this.height,
    this.color = Colors.white,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: color,
            borderRadius: borderRadius,
          ),
        ));
  }
}
