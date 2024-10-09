import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/Constant_styles.dart';

class InfoRow extends StatelessWidget {
  final String iconPath;
  final String text;

  const InfoRow({
    Key? key,
    required this.iconPath,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          width: 24.w,
          height: 24.h,
        ),
        SizedBox(width: 16.w),
        Text(
          text,
          style: ConstantStyles.bodyTextStyle,
        ),
      ],
    );
  }
}
