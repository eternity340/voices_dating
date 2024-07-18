import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//settings & verify 选项条
class PathBox extends StatelessWidget {
  final double top;
  final String text;
  final VoidCallback onPressed;

  const PathBox({
    Key? key,
    required this.top,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: (MediaQuery.of(context).size.width - 335.w) / 2,
      child: Container(
        width: 335.w,
        height: 69.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F9),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.5.h),
          child: Row(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.sp,
                  height: 22.h / 16.sp,
                  letterSpacing: -0.01,
                  color: Colors.black,
                ),
              ),
              Spacer(), // 使用 Spacer 填充 Text 和 IconButton 之间的空间
              IconButton(
                onPressed: onPressed,
                icon: Image.asset(
                  'assets/images/Path.png',
                  width: 18.w,
                  height: 20.h,
                ),
                padding: EdgeInsets.zero, // 去掉内边距
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}