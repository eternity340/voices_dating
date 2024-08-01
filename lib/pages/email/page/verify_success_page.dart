import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../../../entity/User.dart';
import '../../../constants/constant_styles.dart';
import '../../../constants/constant_data.dart';

class VerifySuccessPage extends StatelessWidget {
  final String message;
  final User user;

  VerifySuccessPage({required this.message, required this.user});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil (typically done in main.dart)
    ScreenUtil.init(context, designSize: Size(375, 812), minTextAdapt: true);

    return Scaffold(
      body: Background(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0.w), // Responsive padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100.h), // Responsive height
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 100, // Use constant icon size
                ),
                SizedBox(height: 20.h), // Responsive height
                Text(
                  ConstantData.emailVerificationSuccess,
                  style: ConstantStyles.verifySuccessTitle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h), // Responsive height
                Text(
                  message.isEmpty
                      ? ConstantData.emailVerificationSuccessMessage
                      : message,
                  style: ConstantStyles.verifySuccessSubtitle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 200.h), // Responsive height
                GradientButton(
                  text: ConstantData.nextButtonText,
                  onPressed: () {
                    Get.toNamed('/select_gender', arguments: user);
                  },
                  width: 200.w, // Use constant button width
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
