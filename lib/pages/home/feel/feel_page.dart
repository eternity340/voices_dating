import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/background.dart';
import '../../../components/empty_state_widget.dart';
import '../../../constants/constant_data.dart';
import '../../../utils/common_utils.dart';
import '../components/feel_detail_card.dart';
import 'feel_controller.dart';
import '../../../image_res/image_res.dart'; // 导入你的图片资源

class FeelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FeelController controller = Get.put(FeelController());

    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackButton: true,
            showBackgroundImage: true,
            showMiddleText: true,
            middleText: ConstantData.feelTitleText,
            child: Container(),
          ),
          Obx(() {
            if (controller.isInitialLoading.value) {
              return CommonUtils.loadingIndicator();
            } else if (controller.userList.isEmpty) {
              return Positioned(
                top: 90.h,
                left: 0,
                right: 0,
                bottom: 0,
                child: EmptyStateWidget(
                  imagePath: ImageRes.emptyFeelSvg,
                  message: 'No users available',
                  topPadding: 0.h,
                ),
              );
            } else {
              return Positioned(
                top: 90.h,
                left: 0,
                right: 0,
                bottom: 0,
                child: EasyRefresh(
                  onRefresh: controller.onRefresh,
                  onLoad: controller.onLoad,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.userList.length,
                    itemBuilder: (context, index) {
                      final user = controller.userList[index];
                      return FeelDetailCard(
                        userEntity: user,
                        tokenEntity: controller.tokenEntity,
                      );
                    },
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
