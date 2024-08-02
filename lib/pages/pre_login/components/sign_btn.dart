import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as getx;

import '../../../constants/Constant_styles.dart';
import '../../../constants/constant_data.dart';

class SignBtn extends StatelessWidget {
  const SignBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            getx.Get.toNamed('/sign_in');
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w), // Responsive padding
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF20E2D7), Color(0xFFD8FAAD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r), // Responsive border radius
            ),
            child: Center(
              child: Text(
                ConstantData.signUpText.toUpperCase(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp, // Responsive font size
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h), // Responsive spacing
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              getx.Get.toNamed('/get_mail_code');
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.black, width: 2.0.w), // Responsive border width
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r), // Responsive border radius
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h), // Responsive padding
              child: Text(
                ConstantData.signUpText.toUpperCase(),
                style: ConstantStyles.welcomeButtonStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
