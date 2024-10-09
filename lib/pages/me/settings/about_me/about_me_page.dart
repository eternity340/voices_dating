import 'package:voices_dating/components/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voices_dating/routes/app_routes.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../constants/constant_data.dart';
import '../../../../entity/token_entity.dart';
import '../../../../entity/user_data_entity.dart';
import '../../components/path_box.dart';

class AboutMePage extends StatelessWidget {
  final tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
  final userData = Get.arguments['userDataEntity'] as UserDataEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showMiddleText: true,
            middleText: ConstantData.aboutMe,
            showBackgroundImage: false,
            showBackButton: true,
            child: Container(),
          ),
          Positioned(
            left: 132.w,
            top: 139.h,
            child: Container(
              width: 91.w,
              height: 91.h,
              decoration: BoxDecoration(
                color: Color(0xFFD8D8D8),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          PathBox(
            top: 300.h,
            text: ConstantData.privacyPolicy,
            onPressed: () {
              Get.toNamed(AppRoutes.privacyPolicy);
            },
          ),
          PathBox(
            top: 380.h,
            text: ConstantData.serviceAgreement,
             onPressed: () {
              Get.toNamed(AppRoutes.serviceAgreement);
            },
          ),
          Positioned(
            left: 167.5.w,
            top: 712.5.h,
            child: Text(
              ConstantData.version,
              style: ConstantStyles.aboutMeVersionTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}