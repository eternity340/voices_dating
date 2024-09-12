import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants.dart';
import 'constant_data.dart';

class ConstantStyles {
  //get_email_code
  static  TextStyle welcomeTextStyle =  TextStyle(
    fontSize: 32.sp,
    fontFamily: ConstantData.fontPoppins,
    fontWeight: FontWeight.bold,
    height: 44 / 32,
    letterSpacing: -0.02,
    color: Color(0xFF000000),
  );
  static  TextStyle enterEmailTextStyle =  TextStyle(
    fontSize: 12.sp,
    fontFamily: ConstantData.fontPoppins,
    fontWeight: FontWeight.w500,
    color: Color(0xFF8E8E93),
    letterSpacing: 2.0,
  );
  static  TextStyle emailTextStyle =  TextStyle(
    fontFamily: ConstantData.fontPoppins,
    fontSize: 18.sp,
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
    fontFamily:ConstantData.fontPoppins,
    fontSize: 18.sp,
    height: 22 / 18,
    letterSpacing: -0.01125.w,
    color: Colors.black,
  );
  static TextStyle cancelTextStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 18.sp,
    height: 22 / 18,
    letterSpacing: -0.01125.w,
    color: Colors.red,
  );
  //custom_message_dialog
  static TextStyle dialogCancelTextStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    color: Colors.black,
  );
  static TextStyle yesTextStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    color: Colors.red,
  );
  //detail_bottom_bar
  static TextStyle bottomBarTextStyle = TextStyle(
    fontSize: 16.sp,
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    letterSpacing: 2.0.w,
  );
  static TextStyle likeTextStyle = TextStyle(
    fontSize: 12.sp,
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w500,
  );
  //gradient_button
  static TextStyle gradientButtonTextStyle = TextStyle(
    fontSize: 16.sp,
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    letterSpacing: 2.0.w,
  );
  //select_box
  static TextStyle selectBoxTextStyle = TextStyle(
    fontSize: 16.sp,
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    letterSpacing: -0.01.w,
  );
  //verify_email
  static TextStyle verifyCodeTitleStyle = TextStyle(
    fontSize: 32.sp,
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.bold,
    height: 44 / 32,
    letterSpacing: -0.02,
    color: Color(0xFF000000),
  );
  //verify_email
  static TextStyle verifyCodeTitle = TextStyle(
    fontSize: 32.sp,
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.bold,
    height: 44 / 32,
    letterSpacing: -0.02,
    color: Color(0xFF000000),
  );
  static TextStyle verifyCodeSubtitle = TextStyle(
    fontSize: 12.sp,
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w500,
    color: Color(0xFF8E8E93),
    letterSpacing: 2.0,
  );
  static TextStyle timerText = TextStyle(
    fontSize: 14.sp,
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w400,
    color: Color(0xFF8E8E93),
    height: 24 / 14,
    letterSpacing: -0.01,
  );
  static TextStyle resendButtonText = TextStyle(
    fontSize: 14.sp,
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w400,
    color: Color(0xFF2FE4D4),
    height: 24 / 14,
    letterSpacing: -0.01,
  );
  //verify_success
  static TextStyle verifySuccessTitle = TextStyle(
    fontSize: 32.sp,
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.bold,
    height: 44 / 32,
    letterSpacing: -0.02,
    color: Color(0xFF000000),
  );
  static TextStyle verifySuccessSubtitle = TextStyle(
    fontSize: 16.sp,
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w500,
    color: Color(0xFF8E8E93),
    letterSpacing: 2.0,
  );
  //select_birthday
  static TextStyle birthdayTitleStyle = TextStyle(
  fontSize: 32.sp, // Scaled font size
  fontWeight: FontWeight.bold,
  fontFamily:ConstantData.fontPoppins,
  );
  //select_gender
  static TextStyle genderTitleStyle = TextStyle(
    fontSize: 32.sp, // Responsive font size
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.bold,
    height: 44 / 32, // Line height relative to font size
    letterSpacing: -0.02.sp, // Responsive letter spacing
    color: Color(0xFF000000),
  );
  static TextStyle genderWarningStyle = TextStyle(
    fontSize: 14.sp, // Responsive font size
    height: 24 / 14, // Line height relative to font size
    letterSpacing: -0.01.sp, // Responsive letter spacing
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w500,
    color: Color(0xFF000000),
  );
  //select_height
  static TextStyle heightTitleStyle = TextStyle(
    fontSize: 32.sp, // Responsive font size
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.bold,
    color: Color(0xFF000000),
  );
  //select_location
  static TextStyle locationTitleStyle = TextStyle(
    fontSize: 32.sp, // Responsive font size
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.bold,
    height: 44 / 32, // Line height relative to font size
    letterSpacing: -0.02.sp, // Responsive letter spacing
    color: Color(0xFF000000),
  );
  static TextStyle selectLocationStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  static TextStyle locationListStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  //sign_up
  static TextStyle formLabelStyle = TextStyle(
    fontSize: 12.sp, // Responsive font size
    color: Color(0xFF8E8E93),
    fontFamily:ConstantData.fontPoppins,
  );
  static TextStyle textFieldStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
  );
  static InputDecoration textFieldDecoration = InputDecoration(
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
  //sign_in
  static TextStyle signEmailTextStyle = TextStyle(
    fontSize: 12.sp,
    color: Color(0xFF8E8E93),
    fontFamily:ConstantData.fontPoppins
  );
  static TextStyle passwordTextStyle = TextStyle(
    fontSize: 12.sp,
    color: Color(0xFF8E8E93),
    fontFamily:ConstantData.fontPoppins);
  static TextStyle inputTextStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 18.0.sp);
  static TextStyle signInTextStyle =TextStyle(
    fontSize: 32,
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.bold,
    height: 44 / 32,
    letterSpacing: -0.02,
    color: Color(0xFF000000),
  );
  //welcome
  static TextStyle welcomeButtonStyle = TextStyle(
    color: Colors.black,
    fontSize: 16.sp, // Responsive font size
  );
  //audio_player
  static TextStyle audioTextStyle = TextStyle(
    fontSize: 12.sp, // Responsive font size
    color: Colors.black,
  );
  //profile_card
  static TextStyle usernameTextStyle = TextStyle(
    fontSize: 20.sp,
    fontFamily: ConstantData.fontOpenSans,
    color: Colors.black,
  );
  static TextStyle photoVerifiedTextStyle = TextStyle(
    fontSize: 10.sp,
    fontFamily: ConstantData.fontOpenSans,
    color: Color(0xFF262626),
    letterSpacing: 0.02,
  );
  static TextStyle countryTextStyle = TextStyle(
    fontSize: 12.sp,
    fontFamily: ConstantData.fontOpenSans,
    color: Color(0xFF8E8E93),
  );
  //user_detail_card
  static TextStyle usernameDetailTextStyle = TextStyle(
    fontSize: 18.sp,
    fontFamily: ConstantData.fontOpenSans,
    height: 22 / 18,
    letterSpacing: -0.01125,
    color: Color(0xFF000000),
  );
  static TextStyle locationTextStyle = TextStyle(
    fontSize: 12.sp,
    fontFamily: ConstantData.fontOpenSans,
    color: Color(0xFF8E8E93),
  );
  static TextStyle iconCoinTextStyle = TextStyle(
    fontFamily: 'Open Sans',
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: Color(0xFF3EED86),
  );
  static TextStyle coinTimeTextStyle = TextStyle(
    fontFamily: 'Open Sans',
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: Color(0xFF8E8E93),
  );
  //profile_detail
  static TextStyle headlineStyle = TextStyle(
    fontSize: 18.sp,
    fontFamily: ConstantData.fontOpenSans,
    color: Color(0xFF000000),
    fontWeight: FontWeight.w600,
  );
  static TextStyle bodyTextStyle = TextStyle(
    fontSize: 16.sp,
    fontFamily: ConstantData.fontOpenSans,
    height: 1.5,
    letterSpacing: -0.01,
    color: Color(0xFF000000),
  );
  //home_page
  static TextStyle buttonLabelStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    height: 22 / 14,
    letterSpacing: -0.008750000037252903,
    color: Colors.black,
  );
  static TextStyle verifiedTagStyle =TextStyle(
    fontSize: 10.sp,
    fontFamily: ConstantData.fontOpenSans,
    letterSpacing: 0.02,
    color: const Color(0xFF262626),
  );
  static TextStyle headlineUserCardStyle = TextStyle(
    fontSize: 12.sp,
    fontFamily: ConstantData.fontOpenSans,
    color: Color(0xFF8E8E93),
  );
  static TextStyle homeOptionTextStyle(bool isSelected) => TextStyle(
    fontSize: 26.sp,
    height: 22 / 18,
    letterSpacing: -0.011249999515712261,
    fontFamily: ConstantData.fontOpenSans,
    color: isSelected ? Color(0xFF000000) : Color(0xFF8E8E93),
  );
  //path_box
  static TextStyle pathBoxTextStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 16.sp,
    height: 22 / 16,
    letterSpacing: -0.01,
    color: Colors.black,
  );
  //moments_card
  static TextStyle usernameMomentStyle = TextStyle(
    fontFamily: ConstantData.fontOpenSans,
    fontSize: 14.sp,
    height: 24 / 14,
    color: Color(0xFF000000),
  );
  static TextStyle descriptionStyle = TextStyle(
    fontFamily: ConstantData.fontOpenSans,
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
    height: 24 / 16,
    letterSpacing: -0.01,
    color: Color(0xFF000000),
  );
  //profile_content
  static TextStyle sectionTitle = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    fontFamily:ConstantData.fontPoppins,
    color: Color(0xFF8E8E93),
  );
  static TextStyle sectionValue = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    fontFamily:ConstantData.fontPoppins,
    color: Colors.black,
  );
  static TextStyle saveButtonTextStyle=TextStyle(
  fontFamily:ConstantData.fontPoppins,
  fontSize: 14.sp,
  color: Colors.black,
  );
  //change_headline
  static TextStyle charactersTextStyle=TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 10.0.sp,
    color: Colors.black,
    letterSpacing: 0.02,
  );
  static TextStyle charCountTextStyle=TextStyle(
  fontFamily:ConstantData.fontPoppins,
  fontSize: 10.0.sp,
  color: Color(0xFF8E8E93),
  );
  static TextStyle updateHeadlineTextStyle=TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 14.sp,
    color: Colors.black,
  );
  //change_height
  static TextStyle changeHeightTextStyle=TextStyle(
    fontSize: 32.sp, // Set font size using ScreenUtil
    fontWeight: FontWeight.bold,
    fontFamily:ConstantData.fontPoppins,
  );
  //change_location
  static TextStyle changeLocationTextStyle=TextStyle(
    fontSize: 18.sp,
    fontFamily:ConstantData.fontPoppins,
    color: Colors.black,
  );
  //change_username
  static TextStyle enterUsernameTextStyle=TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 10.sp,
    color: Colors.black,
    letterSpacing: 0.02,
  );
  static TextStyle inputUsernameTextStyle=TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 18.sp,
  );
  //my_profile
  static TextStyle myProfileTitleTextStyle = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    height: 22 / 18,
    letterSpacing: -0.011249999515712261,
    color: Colors.black,
  );
  static TextStyle myProfileOptionTextStyle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    fontFamily:ConstantData.fontPoppins,
    color: Color(0xFF8E8E93),
  );
  static TextStyle optionSelectedTextStyle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    fontFamily:ConstantData.fontPoppins,
    color: Color(0xFF000000),
  );
  //photo
  static TextStyle mainPhotoTextStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    height: 24 / 14,
    letterSpacing: -0.00875,
  );
  //about_me
  static TextStyle aboutMeVersionTextStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w500,
    fontSize: 18.sp,
    color: Colors.black,
  );
  //block_members
  static BoxDecoration blockMemberContainerDecoration = BoxDecoration(
    color: const Color(0xFFF8F8F9),
    borderRadius: BorderRadius.circular(24.r),
    backgroundBlendMode: BlendMode.srcOver,
  );
  static Divider blockMemberDivider = Divider(
    color: Color(0xFFEBEBEB),
    height: 1.h,
    thickness: 1.h,
  );
  //feedback
  static BoxDecoration feedbackContainerDecoration = BoxDecoration(
    color: Color(0xFFF8F8F9),
    borderRadius: BorderRadius.circular(10.r),
  );
  static TextStyle yourIdTextStyle = TextStyle(
    fontSize: 16.sp,
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w500,
    height: 22 / 16,
    letterSpacing: -0.01.sp,
    color: Colors.black,
  );
  static TextStyle feedbackHintStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    height: 24 / 14,
    letterSpacing: -0.01.sp,
    color: Color(0xFF8E8E93),
  );
  static BoxDecoration imageContainerDecoration = BoxDecoration(
    color: Color(0xFFF8F8F9),
    borderRadius: BorderRadius.circular(10.r),
  );
  //settings
  static double pathBoxTopSpacing = 95.h;
  static double signOutButtonTop = 650.h;
  static double signOutButtonHeight = 49.h;
  static double signOutButtonWidth = 248.w;
  //verify_id
  static TextStyle displayTextStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w700,
    fontSize: 20.sp,
    height: 28 / 20, // 行高
    letterSpacing: -0.02, // 字距
    color: Colors.black, // 文本颜色
  );
  static TextStyle followPromptsTextStyle =TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w400,
    fontSize: 12.sp, // 使用 ScreenUtil
    color: Color(0xFF000000), // 黑色
  );
  static TextStyle verifyPhotoTextStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 12.sp,
    color: Colors.black,
  );
  static TextStyle customDialogTitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 22.sp,
    fontWeight: FontWeight.w500,
    height: 22 / 16,
    letterSpacing: -0.01,
    color: Color(0xFF000000),
  );
  static TextStyle customDialogContent = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    height: 22 / 16,
    letterSpacing: -0.01,
    color: Color(0xFF000000),
  );
  //me_page
  static TextStyle mePageUsernameTextStyle = TextStyle(
    fontFamily: ConstantData.fontOpenSans,
    fontWeight: FontWeight.w600,
    fontSize: 20.sp,
    color: Colors.black,
  );
  static TextStyle mePageTextStyle = TextStyle(
    fontFamily: ConstantData.fontOpenSans,
    fontWeight: FontWeight.w600,
    fontSize: 12.sp,
    color: Color(0xFF8E8E93),
  );
  static TextStyle mePageOptionTextStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 18.sp,
    color: Colors.black,
  );
  //moments_page
  static TextStyle hintTextStyle = TextStyle(
    color: Colors.grey,
    fontFamily:ConstantData.fontPoppins,
    fontSize: 18.0.sp,
  );
  static TextStyle smallTextStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 10.0.sp,
    color: Colors.black,
    letterSpacing: 0.02,
  );
  static TextStyle usernameStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    height: 24 / 14,
    letterSpacing: -0.01,
    color: Color(0xFF8E8E93),
  );
  static TextStyle timestampStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w400,
    fontSize: 10.sp,
    height: 24 / 14,
    letterSpacing: -0.01,
    color: Color(0xFF8E8E93),
  );
  static TextStyle commentContentStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    height: 24 / 14,
    letterSpacing: -0.01,
    color: Color(0xFF000000),
  );
  static TextStyle likeCountStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.0071428571827709675,
  );
  static TextStyle momentUsernameTextStyle =  TextStyle(
    fontFamily: ConstantData.fontOpenSans,
    fontSize: 14.sp,
    height: 24 / 14,
    color: Color(0xFF000000),
  );
  static TextStyle timelineDescTextStyle = TextStyle(
    fontFamily: ConstantData.fontOpenSans,
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
    height: 24 / 16,
    letterSpacing: -0.01,
    color: Color(0xFF000000),
  );
  static TextStyle titleStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    height: 22 / 18,
    letterSpacing: -0.01125,
  );
  static TextStyle commentInputStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    height: 24 / 14,
    letterSpacing: -0.01,
    color: Color(0xFF000000),
  );
  static TextStyle commentHintStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    height: 24 / 14,
    letterSpacing: -0.01,
    color: Color(0xFF8E8E93),
  );
  static TextStyle momentsTitleStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.w500,
    fontSize: 18.sp,
    color: Color(0xFF000000),
  );
  static TextStyle addMomentStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontWeight: FontWeight.bold,
    fontSize: 24.sp,
    color: Colors.white,
  );
  //message_page
  static TextStyle usernameMessageStyle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    fontFamily: ConstantData.fontOpenSans,
  );
  static TextStyle lastMassageStyle = TextStyle(
    fontFamily: ConstantData.fontOpenSans,
    fontWeight:  FontWeight.w400,
    fontSize: 14.sp,
    color: Colors.black,
  );
  static TextStyle lastActiveTimeStyle =TextStyle(
    fontSize: 12.sp,
    color: Colors.grey,
  );
  //report_user
  static TextStyle reportOptionStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    height: 22 / 16,
    letterSpacing: -0.01,
    color: Colors.black,
  );
  //user_card
  static TextStyle userCardTextStyle = TextStyle(
    fontSize: 12.sp,
    fontFamily: ConstantData.fontOpenSans,
    color: Color(0xFF8E8E93),
  );
  static TextStyle cardNameTextStyle = TextStyle(
    fontSize: 18.sp,
    fontFamily: ConstantData.fontOpenSans,
    height: 22 / 18,
    letterSpacing: -0.01125,
    color: Color(0xFF000000),
  );
  //record
  static TextStyle recordButtonTextStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: Color(0xFF000000),
  );
  static TextStyle starOrEndTextStyle =TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: Color(0xFF000000),
  );
  static TextStyle timeTextStyle = TextStyle(
    fontFamily:ConstantData.fontPoppins,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    height: 22 / 18,
    letterSpacing: -0.01,
    color: Color(0xFF000000),
  );
  //blockItem
  static TextStyle blockButtonStyle = TextStyle(
    color: Colors.black,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    fontFamily:ConstantData.fontPoppins,
  );
}
