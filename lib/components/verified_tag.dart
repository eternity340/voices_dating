import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/Constant_styles.dart';

class VerifiedTag extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const VerifiedTag({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 19.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7.w),
        child: Center(
          child: Text(
            text,
            style: ConstantStyles.verifiedTagStyle.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}