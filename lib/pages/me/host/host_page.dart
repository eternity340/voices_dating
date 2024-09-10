import 'package:first_app/components/background.dart';
import 'package:first_app/constants/constant_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/Constant_styles.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../image_res/image_res.dart';
import '../components/path_box.dart';

class HostPage extends StatelessWidget {
  final TokenEntity tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
  final UserDataEntity userData = Get.arguments['userDataEntity'] as UserDataEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            child: Container(),
            showMiddleText: true,
            middleText: ConstantData.hostTitle,
            showBackgroundImage: false,
            showBackButton: true,
          ),
          Positioned(
            top: 109.h,
            left: 10.w,
            child: Container(
              width: 335.w,
              height: 161.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                image: DecorationImage(
                  image: AssetImage(ImageRes.hostLiveImagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 200.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                height: 600.h,
                child: Stack(
                  children: [
                    PathBox(
                      top: ConstantStyles.pathBoxTopSpacing,
                      text: ConstantData.emotionalExpertText,
                      onPressed: () {},
                    ),
                    PathBox(
                      top: ConstantStyles.pathBoxTopSpacing + 85.h,
                      text: ConstantData.wakeUpAlarmText,
                      onPressed: () {},
                    ),
                    PathBox(
                      top: ConstantStyles.pathBoxTopSpacing + 170.h,
                      text: ConstantData.gameAccompanimentText,
                      onPressed: () {},
                    ),
                    PathBox(
                      top: ConstantStyles.pathBoxTopSpacing + 255.h,
                      text: ConstantData.nightReliefText,
                      onPressed: () {},
                    ),
                    PathBox(
                      top: ConstantStyles.pathBoxTopSpacing + 340.h,
                      text: ConstantData.lifeGossipText,
                      onPressed: () {},
                    ),
                    PathBox(
                      top: ConstantStyles.pathBoxTopSpacing + 425.h,
                      text: ConstantData.becomePodcastText,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
