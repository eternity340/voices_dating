import 'package:voices_dating/components/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voices_dating/image_res/image_res.dart';
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
            left: ScreenUtil().screenWidth/2-50.h,
            top: 139.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Image.asset(
                  ImageRes.iconVoicesDatingLogo,
                  fit: BoxFit.cover,
                ),
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