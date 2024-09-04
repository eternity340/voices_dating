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
        height: 69.h,
        decoration: BoxDecoration(
          color: isSelected ? Colors.transparent : Color(0xFFF8F8F9),
          borderRadius: BorderRadius.circular(10.r),
          border: isSelected
              ? Border.all(color: Color(0xFFABFFCF), width: 2.w)
              : null,
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                text,
                style: ConstantStyles.selectBoxTextStyle,
              ),
            ),
            Spacer(),
            Container(
              width: 28.w,
              height: 28.h,
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFAAFCCF) : Color(0xFFE1E1E1),
                borderRadius: BorderRadius.circular(14.r),
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
            SizedBox(width: 16.w),
          ],
        ),
      ),
    );
  }
}
