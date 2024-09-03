import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../../../entity/User.dart';
import '../../../constants/constant_styles.dart';
import '../../../constants/constant_data.dart';
import '../../../routes/app_routes.dart';

class VerifySuccessPage extends StatelessWidget {
  final String message;
  final User user;

  VerifySuccessPage({required this.message, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100.h),
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 100,
                ),
                SizedBox(height: 20.h),
                Text(
                  ConstantData.emailVerificationSuccess,
                  style: ConstantStyles.verifySuccessTitle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Text(
                  message.isEmpty
                      ? ConstantData.emailVerificationSuccessMessage
                      : message,
                  style: ConstantStyles.verifySuccessSubtitle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 200.h),
                GradientButton(
                  text: ConstantData.nextButtonText,
                  onPressed: () {
                    Get.toNamed(AppRoutes.selectGender, arguments: user);
                  },
                  width: 200.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
