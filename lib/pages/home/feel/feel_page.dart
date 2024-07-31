import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/background.dart';
import '../components/user_detail_card.dart';
import 'feel_controller.dart';

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
            middleText: '       Feel',
            child: Container(),
          ),
          Obx(() {
            return controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : Positioned(
              top: 100.h,
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
                    final users = controller.userList[index];
                    return UserDetailCard(
                      userEntity: users,
                      tokenEntity: controller.tokenEntity,
                    );
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}