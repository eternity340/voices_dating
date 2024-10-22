import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voices_dating/components/background.dart';
import 'package:voices_dating/constants/Constant_styles.dart';
import 'package:voices_dating/constants/constant_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voices_dating/components/gradient_btn.dart';

import 'delete_account_controller.dart';

class DeleteAccountPage extends StatelessWidget {
  DeleteAccountPage({Key? key}) : super(key: key) {
    Get.put(DeleteAccountController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DeleteAccountController>();
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String password = args['password'] as String? ?? '';

    return SafeArea(
      child: Background(
        showBackgroundImage: false,
        showMiddleText: true,
        middleText: ConstantData.deleteAccountTitle,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60.h),
                  Text(
                    ConstantData.disableAccountDescription,
                    style: ConstantStyles.optionSelectedTextStyle,
                  ),
                  SizedBox(height: 20.h),
                  RichText(
                    text: TextSpan(
                      style: ConstantStyles.aboutMeVersionTextStyle,
                      children: [
                        TextSpan(
                            text: ConstantData.premiumMembershipInfo.split('PREMIUM MEMBER')[0]
                        ),
                        TextSpan(
                          text: 'PREMIUM MEMBER',
                          style: ConstantStyles.aboutMeVersionTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                            text: ConstantData.premiumMembershipInfo.split('PREMIUM MEMBER')[1]
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: Column(
                      children: [
                        GradientButton(
                          text: ConstantData.disableAccountButtonText,
                          onPressed: () => controller.showConfirmationDialog(password),
                          width: 200.w,
                          height: 50.h,
                        ),
                        SizedBox(height: 20.h),
                        TextButton(
                          onPressed: () => controller.showConfirmationDialog(password, permanently: true),
                          child: Text(
                            ConstantData.permanentlyDeleteAccountButtonText,
                            style: ConstantStyles.timerText.copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
