import 'package:first_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../components/all_navigation_bar.dart';
import '../../components/background.dart';
import '../../constants/Constant_styles.dart';
import '../../constants/constant_data.dart';
import '../../image_res/image_res.dart';
import '../../utils/common_utils.dart';
import 'components/moments_card.dart';
import 'moments_controller.dart';

class MomentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MomentsController controller = Get.put(MomentsController());

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await SystemNavigator.pop();
      },
      child: Scaffold(
      body: Stack(
        children: [
          Background(
            showBackButton: false,
            child: Container(),
          ),
          Positioned(
            left: 16.w,
            top: 67.h,
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
          ),
          Positioned(
            left: 90.w,
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
          ),
          /*Positioned(
            right: 10.w,
            top: 59.5.h,
            child: GestureDetector(
              onTap: () {
                // Add your search button onTap logic here
              },
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageRes.buttonRoundSearch),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),*/
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
          AllNavigationBar(tokenEntity: controller.tokenEntity, userData: controller.userDataEntity),
        ],
      ),
    ),
    );
  }

}
