import 'package:voices_dating/components/background.dart';
import 'package:voices_dating/pages/home/get_up/get_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/bottom_options.dart';
import '../../../constants/Constant_styles.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../../image_res/image_res.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/common_utils.dart';
import '../../moments/components/moments_card.dart';
import '../../moments/moments_controller.dart';

class GetUpPage extends StatelessWidget{
  final TokenEntity tokenEntity = Get.arguments['token'] as TokenEntity;
  final UserDataEntity userData = Get.arguments['userData'] as UserDataEntity;

  @override
  Widget build(BuildContext context) {
    final GetUpController controller = Get.put(GetUpController());

    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackButton: true,
            child: Container(),
            showMiddleText: true,
            middleText: ConstantData.viewedText,
          ),
          /*Positioned(
            left: 130.w,
            top: 60.h,
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.momentsAddMoment,
                    arguments: {
                      'tokenEntity': controller.tokenEntity,
                      'userDataEntity': controller.userDataEntity});
              },
              child: Text(
                  ConstantData.moments,
                  style:ConstantStyles.momentsTitleStyle
              ),
            ),
          ),*/
          /*Positioned(
            right: 20.w,
            top: 45.5.h,
            child: GestureDetector(
              onTap: () {
                Get.toNamed(
                    AppRoutes.momentsAddMoment,
                    arguments: {
                      'tokenEntity': controller.tokenEntity,
                      'userDataEntity': controller.userDataEntity});
              },
              child: Container(
                width: 40.w,
                height: 50.h,
                alignment: Alignment.center,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return SweepGradient(
                      colors: [Color(0xFFFFD840), Color(0xFFF3ACFF), Color(0xFF8AECFF), Color(0xFFFFD840)],
                      stops: [0.0, 0.5, 1.0, 1.0],
                      center: Alignment.center,
                    ).createShader(bounds);
                  },
                  child: Text(
                      ConstantData.addMomentText,
                      style: ConstantStyles.addMomentStyle
                  ),
                ),
              ),
            ),
          ),*/
          Positioned(
            right: 10.w,
            top: 55.h,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return BottomOptions(
                      onFirstPressed: () {
                        Navigator.pop(context);
                        Get.toNamed(
                          AppRoutes.momentsAddMoment,
                          arguments: {
                            'tokenEntity': controller.tokenEntity,
                            'userDataEntity': controller.userDataEntity
                          },
                        );
                      },
                      onSecondPressed: () {},
                      onCancelPressed: () {
                        Navigator.pop(context);
                      },
                      firstText: ConstantData.addMomentsText,
                      secondText: '',
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                  ),
                );
              },
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageRes.settingsButtonImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 10.w,
            top: 109.h,
            child: Container(
              width: 335.w,
              height: 650.h,
              child: Obx(() {
                if (controller.isLoading.value && controller.moments.isEmpty) {
                  return CommonUtils.loadingIndicator();
                } else {
                  return EasyRefresh(
                    controller: controller.easyRefreshController,
                    onRefresh: () async => controller.refreshMoments(),
                    onLoad: () async => controller.fetchMoments(),
                    child: ListView.builder(
                      itemCount: controller.moments.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.momentsMomentsDetail,
                                arguments: {
                                  'moment': controller.moments[index],
                                  'tokenEntity': controller.tokenEntity,
                                  'userDataEntity': controller.userDataEntity
                                });
                          },
                          child: MomentsCard(
                            moment: controller.moments[index],
                            tokenEntity: controller.tokenEntity,
                            onLoveButtonPressed: controller.refreshMoments,
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

}