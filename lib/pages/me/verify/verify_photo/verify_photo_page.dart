import 'package:first_app/components/background.dart';
import 'package:first_app/components/gradient_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';
import '../verify_page.dart';

class VerifyPhotoPage extends StatelessWidget {
  final tokenEntity = Get.arguments['token'] as TokenEntity;
  final userData = Get.arguments['userData'] as UserDataEntity;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackgroundImage: false,
            showMiddleText: true,
            showBackButton: true,
            middleText: 'Verify Photo',
            child: Container(),
          ),
          Positioned(
            top: 95.h,
            left: (ScreenUtil().screenWidth - 335.w) / 2,
            child: Container(
              width: 335.w,
              height: 351.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F9),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/icon_pic.png',
                  width: 48.w,
                  height: 48.h,
                ),
              ),
            ),
          ),
          Positioned(
            top: 462.h,
            left: 16.w,
            right: 16.w,
            child: Text(
              'Please upload a live photo and we will analyze whether your photo is yourself.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.sp,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: 572.h, // 字体底部 + 20px
            left: 0,
            right: 0,
            child: Center(
              child: GradientButton(
                text: 'Upload',
                onPressed: () {
                  // Get.to(() => VerifyPage(), arguments: {
                  //   'token': tokenEntity.accessToken,
                  //   'userData': userData,
                  // });
                },
                height: 49.h,
                width: 248.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
