import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/Constant_styles.dart';

class HomeIconButton extends StatelessWidget {
  final String imagePath;
  final Color shadowColor;
  final String label;
  final VoidCallback onTap;

  HomeIconButton({
    required this.imagePath,
    required this.shadowColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 74.w,
            height: 110.h,
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
              child: Image.asset(
                imagePath,
                width: 74.w,
                height: 74.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 0.h), // 图标和文字之间的间距
          Container(
            width: 74.w, // 保持与图标相同的宽度
            child: Text(
              label,
              style: ConstantStyles.buttonLabelStyle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
