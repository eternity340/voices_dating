import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget commonButton({
  required VoidCallback callBack,
  required String buttonTitle,
  double? textSize,
  Color backgroundColor = const Color(0xFF007AFF),
  Color textColor = Colors.white,
  double height = 50,
  double borderRadius = 25,
  bool isEnabled = true,
}) {
  return GestureDetector(
    onTap: isEnabled ? callBack : null,
    child: Container(
      height: height.h,
      decoration: BoxDecoration(
        color: isEnabled ? backgroundColor : backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      child: Center(
        child: Text(
          buttonTitle,
          style: TextStyle(
            color: textColor,
            fontSize: textSize ?? 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
