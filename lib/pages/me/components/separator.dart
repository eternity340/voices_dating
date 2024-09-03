import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget separator() {
  return Column(
    children: [
      SizedBox(height: 20.h),
      Container(
        width: 303.w,
        height: 1.h,
        color: Color(0xFFEBEBEB),
      ),
      SizedBox(height: 30.h),
    ],
  );
}