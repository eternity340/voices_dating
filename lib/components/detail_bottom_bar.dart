import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/widgets.dart';
import 'gradient_btn.dart';

class DetailBottomBar extends StatelessWidget {
  final String gradientButtonText;
  final VoidCallback onGradientButtonPressed;
  final bool showCallButton;
  final bool showMessageButton;
  final bool showLikeButton;

  DetailBottomBar({
    required this.gradientButtonText,
    required this.onGradientButtonPressed,
    this.showCallButton = true,
    this.showMessageButton = true,
    this.showLikeButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      width: 375.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            color: Color(0x5CD4D7E0),
            offset: Offset(0, -20.h),
            blurRadius: 30.w,
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 89.76, sigmaY: 89.76),
          child: Stack(
            children: [
              if (showCallButton)
                Positioned(
                  left: 42.w,
                  top: 14.h,
                  child: Image.asset(
                    'assets/images/icon_call.png',
                    width: 24.w,
                    height: 43.5.h,
                  ),
                ),
              if (showMessageButton)
                Positioned(
                  left: 100.w,
                  top: 14.h,
                  child: Image.asset(
                    'assets/images/icon_message.png',
                    width: 24.w,
                    height: 43.5.h,
                  ),
                ),
              if (showLikeButton)
                Positioned(
                  left: 62.w,
                  top: 14.h,
                  child: Image.asset(
                    'assets/images/icon_bottom_like.png',
                    width: 24.w,
                    height: 43.5.h,
                  ),
                ),
              Positioned(
                left: 150.w,
                top: 12.h,
                child: GradientButton(
                  text: gradientButtonText,
                  onPressed: onGradientButtonPressed,
                  width: 177.w,
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
