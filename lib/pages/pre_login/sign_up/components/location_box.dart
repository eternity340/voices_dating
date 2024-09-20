import 'package:voices_dating/constants/Constant_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationBox extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  LocationBox({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 335.w,
        constraints: BoxConstraints(minHeight: 50.h),
        decoration: BoxDecoration(
          color: Color(0xFFF8F8F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: ConstantStyles.locationListStyle,
            ),
          ),
        ),
      ),
    );
  }
}
