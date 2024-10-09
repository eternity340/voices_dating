import 'package:voices_dating/components/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../constants/Constant_styles.dart';
import '../../../../../constants/constant_data.dart';
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';
import '../../my_profile_page.dart';
import 'change_headline_controller.dart';

class ChangeHeadline extends StatefulWidget {
  @override
  _ChangeHeadlineState createState() => _ChangeHeadlineState();
}

class _ChangeHeadlineState extends State<ChangeHeadline> {
  final ChangeHeadlineController controller = Get.put(ChangeHeadlineController());
  late String initialHeadline;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    final userData = Get.arguments['userDataEntity'] as UserDataEntity;
    initialHeadline = userData.headline ?? '';
    controller.headlineController.text = initialHeadline;
    controller.updateCharCount(initialHeadline);
  }

  @override
  Widget build(BuildContext context) {
    final tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
    final userData = Get.arguments['userDataEntity'] as UserDataEntity;
    void navigateToMeMyProfilePage() {
      Get.to(
            () => MyProfilePage(),
        arguments: {
          'tokenEntity': tokenEntity,
          'userDataEntity': userData,
        },
        transition: Transition.cupertinoDialog,
        duration: Duration(milliseconds: 500),
      );
    }

    return Scaffold(
      body: Background(
        showBackgroundImage: false,
        showMiddleText: true,
        middleText: ConstantData.headlineText,
        showActionButton: false,
        onBackPressed: navigateToMeMyProfilePage,
        usePopScope: true,
        onPopInvoked: navigateToMeMyProfilePage,
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
                  style: ConstantStyles.changeLocationTextStyle,
                  maxLines: null,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  ),
                  onChanged: (text) {
                    controller.updateCharCount(text);
                    setState(() {
                      isButtonEnabled = text.trim().isNotEmpty && text.trim() != initialHeadline;
                    });
                  },
                ),
              ),
            ),
            Positioned(
              top: 286.h,
              left: (MediaQuery.of(context).size.width / 2 - 167.5.w).w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      ConstantData.enterCharactersText,
                      style: ConstantStyles.charactersTextStyle
                  ),
                  SizedBox(width: 180.w),
                  Obx(
                        () => Text(
                        '${controller.charCount}/50',
                        style: ConstantStyles.charCountTextStyle
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0.h,
              right: 0.w,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(-8.w, 0, 0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: isButtonEnabled
                        ? [Color(0xFFD6FAAE), Color(0xFF20E2D7)]
                        : [Color(0xFFC3C3CB), Color(0xFFC3C3CB)],
                  ),
                  borderRadius: BorderRadius.circular(24.5.r),
                ),
                width: 88.w,
                height: 36.h,
                child: TextButton(
                  onPressed: isButtonEnabled
                      ? () => controller.updateHeadline(tokenEntity, userData)
                      : null,
                  child: Text(
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
