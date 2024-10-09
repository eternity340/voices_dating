import 'package:voices_dating/pages/home/user_profile/user_moments/user_moments_controller.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../../../components/background.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../constants/constant_data.dart';
import '../../../moments/components/moments_card.dart';



class UserMomentsPage extends StatelessWidget {
   UserMomentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserMomentsController controller = Get.put(UserMomentsController());

    void refreshMoments() {
      controller.fetchMoments();
    }
    return Scaffold(
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
              },
              child: Text(
                  ConstantData.moments,
                  style:ConstantStyles.momentsTitleStyle
              ),
            ),
          ),
          Positioned(
            left: 20.w,
            top: 109.h,
            child: Container(
              width: 335.w,
              height: 850.h,
              child: Obx(() {
                return EasyRefresh(
                  onRefresh: () async => controller.fetchMoments(),
                  child: ListView.builder(
                    itemCount: controller.moments.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.momentsMomentsDetail,
                              arguments: {
                                'moment': controller.moments[index],
                                'tokenEntity': controller.tokenEntity,
                                'userDataEntity': controller.userDataEntity});
                        },
                        child: MomentsCard(
                          moment: controller.moments[index],
                          tokenEntity: controller.tokenEntity,
                          onLoveButtonPressed: refreshMoments,
                          userDataEntity: controller.userDataEntity,
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

}
