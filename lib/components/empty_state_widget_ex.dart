import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_drawing_animation/svg_drawing_animation.dart';

import '../constants/Constant_styles.dart';

class EmptyStateWidgetEX extends StatelessWidget {
  final String imagePath;
  final String message;
  final TextStyle? textStyle;
  final double? imageWidth;
  final double? imageHeight;
  final double? topPadding;
  final Duration animationDuration;

  const EmptyStateWidgetEX({
    Key? key,
    required this.imagePath,
    required this.message,
    this.textStyle,
    this.imageWidth,
    this.imageHeight,
    this.topPadding,
    this.animationDuration = const Duration(seconds: 1),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: topPadding ?? 180.h),
          SizedBox(
            width: imageWidth ?? 200.w,
            height: imageHeight ?? 200.h,
            child: SvgDrawingAnimation(
              SvgProvider.asset(imagePath),
              duration: animationDuration,
              repeats: false,
              curve: Curves.easeInOut,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            message,
            style: textStyle ?? ConstantStyles.selectLocationStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
