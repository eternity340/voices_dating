import 'package:first_app/pages/home/profile_detail/profile_moments/profile_moments_controller.dart';
import 'package:first_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../../../components/background.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../constants/constant_data.dart';
import '../../../moments/components/moments_card.dart';



class ProfileMomentsPage extends StatelessWidget {
  const ProfileMomentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileMomentsController controller = Get.put(ProfileMomentsController());

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
                            Get.toNamed(AppRoutes.momentsMomentsDetail, arguments: {
                              'moment': controller.moments[index],
                              'tokenEntity': controller.tokenEntity,
                              'userData': controller.userData});
                          },
                          child: MomentsCard(
                            moment: controller.moments[index],
                            tokenEntity: controller.tokenEntity,
                            onLoveButtonPressed: refreshMoments,
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
