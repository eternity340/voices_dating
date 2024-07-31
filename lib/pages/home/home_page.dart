import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/all_navigation_bar.dart';
import '../../components/background.dart';
import '../../constants/constant_data.dart';
import '../../entity/token_entity.dart';
import '../../entity/user_data_entity.dart';
import '../../image_res/image_res.dart';
import 'components/home_icon_button.dart';
import 'components/user_card.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = Get.arguments as Map<String, dynamic>? ?? {};
    final TokenEntity? tokenEntity = arguments['token'] as TokenEntity?;
    final UserDataEntity? userData = arguments['userData'] as UserDataEntity?;

    if (tokenEntity != null && userData != null) {
      Get.put(HomeController(tokenEntity, userData));
    }

    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackButton: false,
            child: Container(),
          ),
          Positioned(
            child: Padding(
              padding: EdgeInsets.all(16.0.sp),
              child: Column(
                children: [
                  SizedBox(height: 50.h),
                  _buildOptionsRow(),
                  _buildButtonRow(tokenEntity, userData),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: _buildAnimatedPageView(),
                  ),
                ],
              ),
            ),
          ),
          if (tokenEntity != null && userData != null)
            AllNavigationBar(tokenEntity: tokenEntity, userData: userData),
        ],
      ),
    );
  }

  Widget _buildOptionsRow() {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Container(
          width: double.infinity,
          height: 40.h,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildOption(controller, ConstantData.honeyOption),
              ),
              Expanded(
                child: _buildOption(controller, ConstantData.nearbyOption),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption(HomeController controller, String option) {
    return Obx(() {
      bool isSelected = controller.selectedOption.value == option;
      return GestureDetector(
        onTap: () => controller.selectOption(option),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isSelected)
              Positioned(
                top: 3,
                right: 45.w,
                child: Image.asset(
                  ImageRes.imagePathDecorate,
                  width: 17.w,
                  height: 17.h,
                ),
              ),
            Text(
              option,
              style: TextStyle(
                fontSize: 26.sp,
                height: 22 / 18,
                letterSpacing: -0.011249999515712261,
                fontFamily: 'Open Sans',
                color: isSelected ? Color(0xFF000000) : Color(0xFF8E8E93),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAnimatedPageView() {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              top: 0.h,
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildPageView(controller),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPageView(HomeController controller) {
    return PageView(
      controller: controller.pageController,
      onPageChanged: controller.onPageChanged,
      children: [
        _buildUserListView(),
        Container(
          child: Center(child: Text('Nearby Page')),
        ),
      ],
    );
  }

  Widget _buildUserListView() {
    final HomeController controller = Get.find<HomeController>();
    return Obx(() {
      return EasyRefresh(
        onRefresh: () async {
          controller.currentPage = 1;
          controller.hasMoreData.value = true;
          controller.users.clear();
          await controller.fetchUsers();
        },
        onLoad: () async {
          await controller.fetchUsers();
        },
        child: ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: UserCard(userEntity: controller.users[index],tokenEntity: controller.tokenEntity),
            );
          },
        ),
      );
    });
  }

  Widget _buildButtonRow(TokenEntity? tokenEntity, UserDataEntity? userData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButtonWithLabel(
          imagePath: ImageRes.imagePathLike,
          shadowColor: Color(0xFFFFD1D1).withOpacity(0.3736),
          label: 'Feel',
          onTap: () {
            if (tokenEntity != null && userData != null) {
              Get.toNamed('/home/feel', arguments: {'token': tokenEntity, 'userData': userData});
            }
          },
        ),
        _buildButtonWithLabel(
          imagePath: ImageRes.imagePathClock,
          shadowColor: Color(0xFFF6D3FF).withOpacity(0.369),
          label: 'Get up',
          onTap: () {
            if (tokenEntity != null && userData != null) {
              Get.toNamed('/home/get_up', arguments: {'token': tokenEntity, 'userData': userData});
            }
          },
        ),
        _buildButtonWithLabel(
          imagePath: ImageRes.imagePathGame,
          shadowColor: Color(0xFFFCA6C5).withOpacity(0.2741),
          label: 'Game',
          onTap: () {
            if (tokenEntity != null && userData != null) {
              Get.toNamed('/home/game', arguments: {'token': tokenEntity, 'userData': userData});
            }
          },
        ),
        _buildButtonWithLabel(
          imagePath: ImageRes.imagePathFeel,
          shadowColor: Color(0xFFFFEA31).withOpacity(0.3495),
          label: 'Gossip',
          onTap: () {
            if (tokenEntity != null && userData != null) {
              Get.toNamed('/home/gossip', arguments: {'token': tokenEntity, 'userData': userData});
            }
          },
        ),
      ],
    );
  }

  Widget _buildButtonWithLabel({
    required String imagePath,
    required Color shadowColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: HomeIconButton(
              imagePath: imagePath,
              shadowColor: shadowColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              height: 22 / 14,
              letterSpacing: -0.008750000037252903,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
