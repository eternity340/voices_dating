import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart'; // 导入 flutter_easyrefresh 包

import '../../components/all_navigation_bar.dart';
import '../../../entity/token_entity.dart';
import '../../components/background.dart';
import '../../entity/moment_entity.dart';
import '../../entity/user_data_entity.dart';
import 'components/moments_card.dart';
import 'moments_controller.dart'; // 导入 MomentsController

class MomentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MomentsController controller = Get.put(MomentsController());

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
                Get.toNamed('/moments/add_moment', arguments: {'token': controller.tokenEntity, 'userData': controller.userData});
              },
              child: Text(
                'Moments',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                  color: Color(0xFF000000),
                ),
              ),
            ),
          ),
          Positioned(
            left: 90.w,
            top: 45.5.h,
            child: GestureDetector(
              onTap: () {
                Get.toNamed('/moments/add_moment', arguments: {'token': controller.tokenEntity, 'userData': controller.userData});
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
                    '+',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                      color: Colors.white, // 白色文本以应用 ShaderMask
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 315.w,
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
                    image: AssetImage('assets/images/button_round_search.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20.w,
            top: 109.h,
            child: Container(
              width: 335.w,
              height: 650.h, // Adjust height to fit more content
              child: EasyRefresh(
                header: ClassicalHeader(
                  refreshText: "Pull to refresh",
                  refreshReadyText: "Release to refresh",
                  refreshingText: "Refreshing...",
                  refreshedText: "Refresh completed",
                  refreshFailedText: "Refresh failed",
                ),
                onRefresh: () async => controller.fetchMoments(),
                child: ListView.builder(
                  itemCount: controller.moments.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed('/moments/moments_detail', arguments: {'moment': controller.moments[index], 'token': controller.tokenEntity, 'userData': controller.userData});
                      },
                      child: MomentsCard(moment: controller.moments[index], tokenEntity: controller.tokenEntity),
                    );
                  },
                )),
              ),
            ),
          AllNavigationBar(tokenEntity: controller.tokenEntity, userData: controller.userData),
        ],
      ),
    );
  }
}
