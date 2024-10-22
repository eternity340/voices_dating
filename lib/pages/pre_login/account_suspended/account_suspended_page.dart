import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voices_dating/components/background.dart';
import 'package:get/get.dart' as getx;
import 'package:voices_dating/constants/Constant_styles.dart';
import 'package:voices_dating/routes/app_routes.dart';

class AccountSuspendedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        showMiddleText: true,
        middleText: 'Suspended',
        child: Stack(
          children: [
            Positioned(
              top: 50.h,
              left: 10.w,
              right: 10.w,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: ConstantStyles.updateHeadlineTextStyle,
                        children: [
                          TextSpan(text: 'It has been suspended due to possible violations of our '),
                          TextSpan(
                            text: 'Service Agreement',
                            style: ConstantStyles.pathBoxTextStyle.copyWith(
                              color: Color(0xFF2FE4D4),
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                getx.Get.toNamed(AppRoutes.serviceAgreement);
                              },
                          ),
                          TextSpan(text: ' or account irregularities. Possible reasons include:'),
                        ],
                      ),
                    ),
                    SizedBox(height: 50.h),
                    _buildBulletPoint('Creating fake / low quality profile'),
                    _buildBulletPoint('Uploading unacceptable content'),
                    _buildBulletPoint('Sending spam or other "junk" email to other members'),
                    _buildBulletPoint('Suspicious account activity (registration, login, etc ...)'),
                    SizedBox(height: 200.h),
                    Text(
                      'Your account and photos have been removed from the public view.',
                      style: ConstantStyles.updateHeadlineTextStyle,
                    ),
                    SizedBox(height: 10.h),
                    RichText(
                      text: TextSpan(
                        style: ConstantStyles.updateHeadlineTextStyle,
                        children: [
                          TextSpan(text: 'If you believe that you have received this message in error then please '),
                          TextSpan(
                            text: 'contact us',
                            style: ConstantStyles.pathBoxTextStyle.copyWith(
                              color: Color(0xFF2FE4D4),
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                getx.Get.toNamed(AppRoutes.preFeedback);
                              },
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: ConstantStyles.updateHeadlineTextStyle),
          Expanded(
            child: Text(
              text,
              style: ConstantStyles.updateHeadlineTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
