import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final TextStyle? textStyle;

  var height; // 声明 textStyle 参数

  GradientButton({required this.text, required this.onPressed, this.width ,this.height , this.textStyle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? 248,
        height: height ?? 49,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF20E2D7), Color(0xFFD8FAAD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text.toUpperCase(),
            style: textStyle ?? const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Colors.black,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
