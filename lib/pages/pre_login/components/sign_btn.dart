import 'package:flutter/gestures.dart';
import 'package:voices_dating/entity/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as getx;
import 'package:voices_dating/routes/app_routes.dart';
import '../../../constants/Constant_styles.dart';
import '../../../constants/constant_data.dart';

class SignBtn extends StatefulWidget {
  const SignBtn({Key? key}) : super(key: key);

  @override
  _SignBtnState createState() => _SignBtnState();
}

class _SignBtnState extends State<SignBtn> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 150.h,
            child: GestureDetector(
              onTap: _isChecked ? () => getx.Get.toNamed(AppRoutes.signIn) : null,
              child: Opacity(
                opacity: _isChecked ? 1.0 : 0.5,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF20E2D7), Color(0xFFD8FAAD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: Text(
                      ConstantData.signInText.toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 80.h,
            child: Opacity(
              opacity: _isChecked ? 1.0 : 0.5,
              child: OutlinedButton(
                onPressed: _isChecked ? () => getx.Get.toNamed(AppRoutes.getMailCode) : null,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black, width: 2.0.w),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    ConstantData.signUpText.toUpperCase(),
                    style: ConstantStyles.welcomeButtonStyle,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                  shape: CircleBorder(),
                  checkColor: Colors.white,
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Color(0xFF2FE4D4);
                    }
                    return Colors.transparent;
                  }),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: ConstantStyles.verifyPhotoTextStyle,
                      children: [
                        TextSpan(text: ConstantData.ppsaContent),
                        TextSpan(
                          text: ConstantData.serviceAgreement,
                          style: TextStyle(
                            color: Color(0xFF2FE4D4),
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              getx.Get.toNamed(AppRoutes.serviceAgreement);
                            },
                        ),
                        TextSpan(text: ConstantData.andText),
                        TextSpan(
                          text: ConstantData.privacyPolicy,
                          style: TextStyle(
                            color: Color(0xFF2FE4D4),
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              getx.Get.toNamed(AppRoutes.privacyPolicy);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
