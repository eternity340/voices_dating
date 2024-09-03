import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class HomeIconButton extends StatelessWidget {
  final String imagePath;
  final Color shadowColor;

  HomeIconButton({required this.imagePath, required this.shadowColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 120.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(0, 7),
            blurRadius: 15,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(imagePath),
      ),
    );
  }
}
