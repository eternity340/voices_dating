// 自定义外部椭圆形的线圈Painter
import 'package:flutter/cupertino.dart';

class OuterOvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const Gradient gradient = SweepGradient(
      startAngle: 0.0,
      endAngle: 2 * 3.14,
      colors: [
        Color(0xFFF3ADF8),
        Color(0xFFFAC492),
        Color(0xFFF9C39D),
        Color(0xFF8BEAFF),
        Color(0xFF8AECFF),
        Color(0xFFBFCCFF),
      ],
      stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
    );

    final Paint paint = Paint()..shader = gradient.createShader(rect);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4.0;

    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}