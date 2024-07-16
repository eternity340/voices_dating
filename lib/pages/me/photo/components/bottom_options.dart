import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomOptions extends StatelessWidget {
  final VoidCallback onFirstPressed;
  final VoidCallback onSecondPressed;
  final VoidCallback onCancelPressed;
  final String firstText;
  final String secondText;

  const BottomOptions({
    Key? key,
    required this.onFirstPressed,
    required this.onSecondPressed,
    required this.onCancelPressed,
    required this.firstText,
    required this.secondText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: onFirstPressed,
            child: Text(
              firstText,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                height: 22 / 18,
                letterSpacing: -0.01125,
                color: Colors.black,
              ),
            ),
          ),
          const Divider(
            color: Color(0xFFE0E0E0),
            thickness: 1,
            height: 24,
          ),
          TextButton(
            onPressed: onSecondPressed,
            child: Text(
              secondText,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                height: 22 / 18,
                letterSpacing: -0.01125,
                color: Colors.black,
              ),
            ),
          ),
          const Divider(
            color: Color(0xFFE0E0E0),
            thickness: 1,
            height: 24,
          ),
          TextButton(
            onPressed: onCancelPressed,
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                height: 22 / 18,
                letterSpacing: -0.01125,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
