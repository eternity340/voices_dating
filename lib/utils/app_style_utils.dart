import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyleUtils {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    dividerColor: bgGroundColor.withOpacity(0.7),
    primaryColorLight: const Color(0x996d7499),
    hintColor: hintColor,
    scaffoldBackgroundColor: bgGroundColor,
    focusColor: const Color(0xff222222),
    splashColor: primaryColor.withOpacity(0.05),
    cupertinoOverrideTheme: CupertinoThemeData.raw(
        Brightness.light,
        primaryColor,
        primaryColor,
        const CupertinoTextThemeData(),
        bgGroundColor,
        bgGroundColor,
        true),
    // 添加 textSelectionTheme 来设置光标颜色
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Color(0xFF20E2D7),
    ),
  );

  static TextStyle get titleStyles => TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold,color: textColor);
  static TextStyle get labelStyles => TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black);
  static TextStyle get subLabelStyles => TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w400,color: const Color(0xff2c2c2c));
  static TextStyle get hintStyles => TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w400,color: Color(0xff999999));
  static TextStyle get inputStyles => TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400,color: textColor);
  static TextStyle get buttonTextStyles => TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w400,color: Colors.black);


  static Color get bgGroundColor => const Color(0xffffffff);
  static Color get primaryColor => const Color(0xff000000);
  static Color get hintColor => const Color(0xffaaaaaa);
  static Color get inputBorderColor => const Color(0xff000000);
  static Color get errorContainerColor => const Color(0xffea6565);
  static Color get disableTextColor => const Color(0xff666666);
  static Color get textColor => const Color(0xff000000);
  static Color get itemSelectedColor => const Color(0xffffae85);

  static Color get splashBackgroundColor => const Color(0xFF9FD5B7);
  static Color get discoverNameBgColor => const Color(0xFFA2D6B9);

  static Color get verifyBgColor => const Color(0xFFFFF1D5);
  static Color get wfYellowColor => const Color(0xFFFFE6B5);
  static Color get orangePaymentField => const Color(0xFFEB7561);
  static Color get messageReceiverColor => const Color(0xFFF5F9Fa);




}