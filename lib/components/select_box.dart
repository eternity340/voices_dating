import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/constant_data.dart';
import '../constants/constant_styles.dart'; // 导入ConstantStyles

class SelectBox extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  SelectBox({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 69.h, // 使用ScreenUtil来适配高度
        decoration: BoxDecoration(
          color: isSelected ? Colors.transparent : Color(0xFFF8F8F9),
          borderRadius: BorderRadius.circular(10.r), // 使用ScreenUtil来适配圆角
          border: isSelected
              ? Border.all(color: Color(0xFFABFFCF), width: 2.w) // 使用ScreenUtil来适配边框宽度
              : null,
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w), // 使用ScreenUtil来适配内边距
              child: Text(
                text,
                style: ConstantStyles.selectBoxTextStyle,
              ),
            ),
            Spacer(),
            Container(
              width: 28.w, // 使用ScreenUtil来适配宽度
              height: 28.h, // 使用ScreenUtil来适配高度
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFAAFCCF) : Color(0xFFE1E1E1),
                borderRadius: BorderRadius.circular(14.r), // 使用ScreenUtil来适配圆角
              ),
              child: isSelected
                  ? const Center(
                child: Icon(
                  Icons.check,
                  size: 20,
                  color: Color(0xFF3B3B3B),
                ),
              )
                  : null,
            ),
            SizedBox(width: 16.w), // 使用ScreenUtil来适配宽度
          ],
        ),
      ),
    );
  }
}
