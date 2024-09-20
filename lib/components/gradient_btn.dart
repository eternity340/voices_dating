import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/Constant_styles.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final String? iconPath;
  final bool isDisabled;

  GradientButton({
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.textStyle,
    this.iconPath,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : (onPressed ?? () {}),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: width?.w ?? 248.w,
        height: height?.h ?? 49.h,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDisabled
                ? [Color(0xFFC3C3CB), Color(0xFFC3C3CB)]
                : [Color(0xFF20E2D7), Color(0xFFD8FAAD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconPath != null) ...[
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: Image.asset(
                    iconPath!,
                    key: ValueKey<bool>(isDisabled),
                    width: 24.w,
                    height: 24.h,
                    color: isDisabled ? Colors.grey : null,
                  ),
                ),
                SizedBox(width: 8.w),
              ],
              AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 300),
                style: isDisabled
                    ? ConstantStyles.bottomBarTextStyle
                    : ConstantStyles.bottomBarTextStyle,
                child: Text(text.toUpperCase()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
