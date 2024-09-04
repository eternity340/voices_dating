import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_style_utils.dart';

class BottomButton extends StatelessWidget {
  static final double defaultHeight = 40.h;
  static final double defaultWidth = 248.w;

  final String label;
  final VoidCallback onButtonPress;
  final Color? color;
  final Color? textColor;
  final bool enable;
  final double? textSize;
  final double? width;
  final double? height;
  final BorderSide? borderSide;
  final double? radius;
  final Decoration? decoration;

  const BottomButton(
      {Key? key,
        required this.onButtonPress,
        required this.label,
        this.color,
        this.textColor,
        this.enable = true,
        this.textSize,
        this.width,
        this.height,
        this.borderSide,
        this.radius,
        this.decoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          height: height ?? defaultHeight,
          width: width ?? defaultWidth,
          decoration: decoration,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: enable
                    ? color ?? Theme.of(context).primaryColor
                    : Colors.white.withOpacity(0.05),
                foregroundColor: enable
                    ? textColor ?? Colors.white
                    : Colors.white.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(radius ?? 20.r)),
                    side: borderSide ?? BorderSide.none),
                disabledBackgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              ),
              onPressed: enable ? () => onButtonPress() : null,
              child: Text(
                label,
                style: AppStyleUtils.labelStyles,
              )),
        ),
      ],
    );
  }
}