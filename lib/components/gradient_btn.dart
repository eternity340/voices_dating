import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/constant_data.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final TextStyle? textStyle;

  GradientButton({
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {},
      child: Container(
        width: width?.w ?? 248.w,
        height: height?.h ?? 49.h,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF20E2D7), Color(0xFFD8FAAD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Center(
          child: Text(
            text.toUpperCase(),
            style: textStyle ??
                TextStyle(
                  fontSize: 16.sp,
                  fontFamily: ConstantData.fontPoppins,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
          ),
        ),
      ),
    );
  }
}
