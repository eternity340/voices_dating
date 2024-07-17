import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class CirclePainter extends CustomPainter {
  final List<Color> rectColors;
  final List<double> rectScales;

  CirclePainter({required this.rectColors, required this.rectScales});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // 绘制矩形
    final double rectWidth = 11.06.w;
    final double rectHeight = 2.h;
    final double rectRadius = 1.w;
    final double distanceFromCircle = 9.h;

    for (int i = 0; i < rectColors.length; i++) {
      // 从12点开始计算角度
      final double angle = (i * 4 * (math.pi / 180)) - (math.pi / 2);
      final double rectCenterX = centerX + (radius + distanceFromCircle + rectHeight / 2) * math.cos(angle);
      final double rectCenterY = centerY + (radius + distanceFromCircle + rectHeight / 2) * math.sin(angle);

      final Paint rectPaint = Paint()
        ..color = rectColors[i]
        ..style = PaintingStyle.fill;

      // 矩形缩放
      final double scale = rectScales[i];

      canvas.save();
      canvas.translate(rectCenterX, rectCenterY);
      canvas.rotate(angle);
      canvas.scale(scale, scale); // 放大
      final RRect rRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(0, 0), width: rectWidth, height: rectHeight),
        Radius.circular(rectRadius),
      );
      canvas.drawRRect(rRect, rectPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}