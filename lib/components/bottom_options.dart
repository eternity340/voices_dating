import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/constant_styles.dart';
import '../constants/constant_data.dart';

class BottomOptions extends StatelessWidget {
  final VoidCallback onFirstPressed;
  final VoidCallback onSecondPressed;
  final VoidCallback onCancelPressed;
  final String firstText;
  final String secondText;

  const BottomOptions({
    super.key,
    required this.onFirstPressed,
    required this.onSecondPressed,
    required this.onCancelPressed,
    required this.firstText,
    required this.secondText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: onFirstPressed,
            child: Text(
              firstText,
              style: ConstantStyles.optionTextStyle,
            ),
          ),
          if (secondText.isNotEmpty) ...[
            Divider(
              color: Color(0xFFE0E0E0),
              thickness: 1.h,
              height: 24.h,
            ),
            TextButton(
              onPressed: onSecondPressed,
              child: Text(
                secondText,
                style: ConstantStyles.optionTextStyle,
              ),
            ),
          ],
          Divider(
            color: Color(0xFFE0E0E0),
            thickness: 1.h,
            height: 24.h,
          ),
          TextButton(
            onPressed: onCancelPressed,
            child: Text(
              ConstantData.CancelText,
              style: ConstantStyles.cancelTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
