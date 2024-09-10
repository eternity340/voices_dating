import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../components/background.dart';
import '../../../../../constants/Constant_styles.dart';
import '../../../../../constants/constant_data.dart';
import '../../../../../entity/token_entity.dart';
import '../../../../../entity/user_data_entity.dart';
import '../../../../pre_login/sign_up/components/height_picker.dart';
import 'change_height_controller.dart';

class ChangeHeight extends StatefulWidget {
  @override
  _ChangeHeightState createState() => _ChangeHeightState();
}

class _ChangeHeightState extends State<ChangeHeight> {
  final ChangeHeightController _controller = ChangeHeightController();
  bool isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    final TokenEntity tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
    final UserDataEntity userData = Get.arguments['userDataEntity'] as UserDataEntity;
    return Scaffold(
      body: Background(
        showBackgroundImage: false,
        showActionButton: false,
        showMiddleText: true,
        middleText: ConstantData.heightHeadTitle,
        child: Stack(
          children: [
            Positioned(
              top: 100.h,
              left: 0.w,
              right: 0.w,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      ConstantData.changeHeightText,
                      style: ConstantStyles.changeHeightTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50.h),
                    HeightPicker(
                      initialHeight: _controller.selectedHeight,
                      onHeightChanged: (newHeight) {
                        setState(() {
                          _controller.selectedHeight = newHeight;
                          isButtonEnabled = true;
                        });
                      },
                    ),
                  ],
                ),
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
                      ? () => _controller.updateHeight(tokenEntity, userData)
                      : null,
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
