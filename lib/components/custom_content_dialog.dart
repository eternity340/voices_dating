import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voices_dating/constants/Constant_styles.dart';
import '../../../../components/gradient_btn.dart';

class CustomContentDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const CustomContentDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.buttonText,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 335.w,
          maxHeight: 500.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30.5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                title,
                style: ConstantStyles.customDialogTitle,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.5.h),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    content,
                    style: ConstantStyles.customDialogContent,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: GradientButton(
                text: buttonText,
                onPressed: onButtonPressed,
                width: 150.w,  // Increased width
                height: 49.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
