import 'package:voices_dating/constants/Constant_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ReportOption extends StatelessWidget {
  final String optionText;
  final bool isSelected;
  final VoidCallback onSelect;

  const ReportOption({
    Key? key,
    required this.optionText,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        width: 335.w,
        height: 69.h,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Color(0xFFF8F8F9),
          borderRadius: BorderRadius.circular(10.r),
          border: isSelected
              ? Border.all(color: Color(0xFF32EA76), width: 2)
              : null,
        ),
        child: Stack(
          children: [
            Positioned(
              left: isSelected ? 16.w : 18.w,
              top: isSelected ? 21.5.h : 23.5.h,
              child: Text(
                optionText,
                style:ConstantStyles.reportOptionStyle
              ),
            ),
            Positioned(
              left: isSelected ? 289.w : 291.w,
              top: isSelected ? 18.5.h : 20.5.h,
              child: Container(
                width: 28.w,
                height: 28.h,
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFAAFCCF) : Color(0xFFE1E1E1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: isSelected
                    ? Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20.sp,
                )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}