import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constant_data.dart';

class ConstantStyles {
  //get_email_code
  static const TextStyle welcomeTextStyle =  TextStyle(
    fontSize: 32,
    fontFamily: ConstantData.fontPoppins,
    fontWeight: FontWeight.bold,
    height: 44 / 32,
    letterSpacing: -0.02,
    color: Color(0xFF000000),
  );
  static const TextStyle enterEmailTextStyle =  TextStyle(
    fontSize: 12,
    fontFamily: ConstantData.fontPoppins,
    fontWeight: FontWeight.w500,
    color: Color(0xFF8E8E93),
    letterSpacing: 2.0,
  );
  static const TextStyle emailTextStyle =  TextStyle(
    fontFamily: ConstantData.fontPoppins,
    fontSize: 18,
  );
  //background
  static TextStyle backButtonTextStyle = TextStyle(
    fontFamily: ConstantData.fontPoppins,
    fontSize: 14.sp,
    color: Colors.black,
    letterSpacing: 2.w,
  );
  static TextStyle middleTextStyle = TextStyle(
    fontFamily: ConstantData.fontPoppins,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    height: 22 / 18,
    color: Colors.black,
  );
  static TextStyle actionButtonTextStyle = TextStyle(
    fontFamily: ConstantData.fontPoppins,
    fontSize: 14.sp,
    color: Colors.black,
  );
  //bottom_options
  static TextStyle optionTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18.sp,
    height: 22 / 18,
    letterSpacing: -0.01125.w,
    color: Colors.black,
  );
  static TextStyle cancelTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18.sp,
    height: 22 / 18,
    letterSpacing: -0.01125.w,
    color: Colors.red,
  );
  //custom_message_dialog
  static TextStyle dialogCancelTextStyle = TextStyle(
    fontFamily: 'Poppins',
    color: Colors.black,
  );
  static TextStyle yesTextStyle = TextStyle(
    fontFamily: 'Poppins',
    color: Colors.red,
  );
  //detail_bottom_bar
  static TextStyle bottomBarTextStyle = TextStyle(
    fontSize: 16.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    color: Colors.black,
    letterSpacing: 2.0.w,
  );
  static TextStyle likeTextStyle = TextStyle(
    fontSize: 12.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );
  //gradient_button
  static TextStyle gradientButtonTextStyle = TextStyle(
    fontSize: 16.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    color: Colors.black,
    letterSpacing: 2.0.w,
  );
  //select_box
  static TextStyle selectBoxTextStyle = TextStyle(
    fontSize: 16.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    color: Colors.black,
    letterSpacing: -0.01.w,
  );
  //verify_email
  static TextStyle verifyCodeTitleStyle = TextStyle(
    fontSize: 32.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    height: 44 / 32,
    letterSpacing: -0.02,
    color: Color(0xFF000000),
  );
  //verify_email
  static TextStyle verifyCodeTitle = TextStyle(
    fontSize: 32.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    height: 44 / 32,
    letterSpacing: -0.02,
    color: Color(0xFF000000),
  );
  static TextStyle verifyCodeSubtitle = TextStyle(
    fontSize: 12.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    color: Color(0xFF8E8E93),
    letterSpacing: 2.0,
  );
  static TextStyle timerText = TextStyle(
    fontSize: 14.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    color: Color(0xFF8E8E93),
    height: 24 / 14,
    letterSpacing: -0.01,
  );
  static TextStyle resendButtonText = TextStyle(
    fontSize: 14.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    color: Color(0xFF2FE4D4),
    height: 24 / 14,
    letterSpacing: -0.01,
  );
  //verify_success
  static TextStyle verifySuccessTitle = TextStyle(
    fontSize: 32.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    height: 44 / 32,
    letterSpacing: -0.02,
    color: Color(0xFF000000),
  );
  static TextStyle verifySuccessSubtitle = TextStyle(
    fontSize: 16.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    color: Color(0xFF8E8E93),
    letterSpacing: 2.0,
  );
  //select_birthday
  static TextStyle birthdayTitleStyle = TextStyle(
  fontSize: 32.sp, // Scaled font size
  fontWeight: FontWeight.bold,
  fontFamily: 'Poppins',
  );
  //select_gender
  static TextStyle genderTitleStyle = TextStyle(
    fontSize: 32.sp, // Responsive font size
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    height: 44 / 32, // Line height relative to font size
    letterSpacing: -0.02.sp, // Responsive letter spacing
    color: Color(0xFF000000),
  );
  static TextStyle genderWarningStyle = TextStyle(
    fontSize: 14.sp, // Responsive font size
    height: 24 / 14, // Line height relative to font size
    letterSpacing: -0.01.sp, // Responsive letter spacing
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    color: Color(0xFF000000),
  );
  //select_height
  static TextStyle heightTitleStyle = TextStyle(
    fontSize: 32.sp, // Responsive font size
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    color: Color(0xFF000000),
  );
  //select_location
  static TextStyle locationTitleStyle = TextStyle(
    fontSize: 32.sp, // Responsive font size
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    height: 44 / 32, // Line height relative to font size
    letterSpacing: -0.02.sp, // Responsive letter spacing
    color: Color(0xFF000000),
  );
  //sign_up
  static  TextStyle formLabelStyle = TextStyle(
    fontSize: 12.sp, // Responsive font size
    color: Color(0xFF8E8E93),
    fontFamily: 'Poppins',
  );
  static  TextStyle textFieldStyle = TextStyle(
    fontFamily: 'Poppins',
  );
  static  InputDecoration textFieldDecoration = InputDecoration(
    hintText: null,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1.w),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1.w),
    ),
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 1.w),
    ),
  );
}
