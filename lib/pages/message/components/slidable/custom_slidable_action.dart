import 'package:flutter/cupertino.dart';
import 'package:voices_dating/pages/message/components/slidable/rounded_rectangle_painter.dart';

class CustomSlidableAction extends StatelessWidget {
  final Function(BuildContext) onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
  final String label;

  const CustomSlidableAction({
    Key? key,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(context),
      child: CustomPaint(
        painter: RoundedRectanglePainter(backgroundColor),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foregroundColor),
              SizedBox(height: 4),
              Text(label, style: TextStyle(color: foregroundColor)),
            ],
          ),
        ),
      ),
    );
  }
}