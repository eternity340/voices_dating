import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../components/background.dart';
import '../../../../../constants/Constant_styles.dart';
import '../../../../../constants/constant_data.dart';
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';
import 'change_username_controller.dart';

class ChangeUsername extends StatefulWidget {
  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final ChangeUsernameLogic logic = Get.put(ChangeUsernameLogic());

  @override
  Widget build(BuildContext context) {
    final tokenEntity = Get.arguments['token'] as TokenEntity;
    final userData = Get.arguments['userData'] as UserDataEntity;

    return Scaffold(
      body: Background(
        showBackgroundImage: false,
        showMiddleText: true,
        middleText: ConstantData.usernameTitle,
        showActionButton: false,
        child: Stack(
          children: [
            Positioned(
              top: 80.h,
              left: MediaQuery.of(context).size.width / 2 - 167.5.w, // Use ScreenUtil for width
              child: Container(
                width: 335.w,
                height: 56.h,
                decoration: BoxDecoration(
                  color: Color(0xFFF8F8F9),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextField(
                  controller: logic.controller,
                  style: ConstantStyles.inputUsernameTextStyle,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h), // Use ScreenUtil for padding
                  ),
                  onChanged: (text) {
                    setState(() {
                      logic.charCount = text.length;
                    });
                  },
                ),
              ),
            ),
            Positioned(
              top: 141.h, // 80 + 56 + 5, converted to ScreenUtil
              left: MediaQuery.of(context).size.width / 2 - 167.5.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ConstantData.enterUsernameText,
                    style: ConstantStyles.enterUsernameTextStyle,
                  ),
                  SizedBox(width: 190.w),
                  Text(
                    '${logic.charCount}/16',
                    style:ConstantStyles.charCountTextStyle,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 4.h, // Converted to ScreenUtil
              right: 16.w, // Converted to ScreenUtil
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(-8.w, 0, 0), // Use ScreenUtil for translation
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFD6FAAE), Color(0xFF20E2D7)],
                  ),
                  borderRadius: BorderRadius.circular(24.5.r), // Use ScreenUtil for radius
                ),
                width: 88.w,
                height: 36.h,
                child: TextButton(
                  onPressed: () => logic.saveUsername(tokenEntity, userData),
                  child: Text(
                    ConstantData.saveText,
                    style: ConstantStyles.saveButtonTextStyle,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
