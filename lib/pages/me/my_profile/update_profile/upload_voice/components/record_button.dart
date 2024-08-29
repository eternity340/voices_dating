import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordButton extends StatefulWidget {
  final VoidCallback onLongPressStart;
  final VoidCallback onLongPressEnd;

  RecordButton({required this.onLongPressStart, required this.onLongPressEnd});

  @override
  _RecordButtonState createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) {
        setState(() => _isPressed = true);
        widget.onLongPressStart();
      },
      onLongPressEnd: (_) {
        setState(() => _isPressed = false);
        widget.onLongPressEnd();
      },
      child: Container(
        width: 90.w,
        height: 90.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Color(0xFF3B3B3B), width: 4.w),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            width: _isPressed ? 28.w : 70.w,
            height: _isPressed ? 28.h : 70.h,
            decoration: BoxDecoration(
              color: Color(0xFF3B3B3B),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}