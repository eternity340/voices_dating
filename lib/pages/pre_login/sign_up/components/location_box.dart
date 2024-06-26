import 'package:flutter/material.dart';

class LocationBox extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  LocationBox({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 335,
        height: 69,
        decoration: BoxDecoration(
          color: Color(0xFFF8F8F9), // 背景颜色
          borderRadius: BorderRadius.circular(10), // 圆角
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // 内边距
          child: Align(
            alignment: Alignment.centerLeft, // 左对齐
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
