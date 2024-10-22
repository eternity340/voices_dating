import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/Constant_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  final String imagePath;
  final String message;
  final TextStyle? textStyle;
  final double? imageWidth;
  final double? imageHeight;
  final double? topPadding;

  const EmptyStateWidget({
    Key? key,
    required this.imagePath,
    required this.message,
    this.textStyle,
    this.imageWidth,
    this.imageHeight,
    this.topPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: topPadding ?? 180.h),
          SvgPicture.asset(
            imagePath,
            width: imageWidth ?? 200.w,
            height: imageHeight ?? 200.h,
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
