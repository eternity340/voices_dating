// pages/change_headline_page.dart
import 'package:first_app/components/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../constants/Constant_styles.dart';
import '../../../../../constants/constant_data.dart';
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';
import 'change_headline_controller.dart';

class ChangeHeadline extends StatelessWidget {
  final ChangeHeadlineController controller = Get.put(ChangeHeadlineController());

  @override
  Widget build(BuildContext context) {
    final tokenEntity = Get.arguments['token'] as TokenEntity;
    final userData = Get.arguments['userData'] as UserDataEntity;

    return Scaffold(
      body: Background(
        showBackgroundImage: false,
        showMiddleText: true,
        middleText: ConstantData.headlineText,
        showActionButton: false,
        child: Stack(
          children: [
            Positioned(
              top: 80.h,
              left: (MediaQuery.of(context).size.width / 2 - 167.5.w).w,
              child: Container(
                width: 335.0.w,
                height: 200.0.h,
                decoration: BoxDecoration(
                  color: Color(0xFFF8F8F9),
                  borderRadius: BorderRadius.circular(10.0.r),
                ),
                child: TextField(
                  controller: controller.headlineController,
                  style:  TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18.0.sp,
                  ),
                  maxLines: null,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  ),
                  onChanged: (text) {
                    controller.updateCharCount(text);
                  },
                ),
              ),
            ),
            Positioned(
              top: 286.h, // Adjusted to 80.h + 200.h + 6.h
              left: (MediaQuery.of(context).size.width / 2 - 167.5.w).w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                     ConstantData.enterCharactersText,
                    style:ConstantStyles.charactersTextStyle
                   ),
                   SizedBox(width: 180.w),
                  Obx(
                        () => Text(
                      '${controller.charCount}/50',
                      style:ConstantStyles.charCountTextStyle
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 4.0.h,
              right: 16.0.w,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(-8.w, 0, 0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFD6FAAE), Color(0xFF20E2D7)],
                  ),
                  borderRadius: BorderRadius.circular(24.5.r),
                ),
                width: 88.w,
                height: 36.h,
                child: TextButton(
                  onPressed: () => controller.updateHeadline(tokenEntity, userData),
                  child:  Text(
                    ConstantData.updateHeadlineText,
                    style: ConstantStyles.updateHeadlineTextStyle,
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
