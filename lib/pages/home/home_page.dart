import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/all_navigation_bar.dart';
import '../../components/background.dart';
import '../../constants/constant_data.dart';
import '../../entity/list_user_entity.dart';
import '../../entity/token_entity.dart';
import '../../entity/user_data_entity.dart';
import '../../image_res/image_res.dart';
import 'components/home_icon_button.dart';
import 'components/user_card.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = Get.arguments as Map<String, dynamic>;
    final TokenEntity tokenEntity = arguments['token'] as TokenEntity;
    final UserDataEntity userData = arguments['userData'] as UserDataEntity;
    Get.put(HomeController(tokenEntity, userData));

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
                  _buildButtonRow(),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: _buildAnimatedPageView(),
                  ),
                ],
              ),
            ),
          ),
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
    return Obx(() {
      final controller = Get.find<HomeController>();
      return ListView.builder(
        itemCount: controller.users.length + (controller.hasMoreData.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.users.length) {
            // 在列表末尾显示加载指示器
            return Center(child: CupertinoActivityIndicator());
          }
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: UserCard(userEntity: controller.users[index]),
          );
        },
      );
    });
  }

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButtonWithLabel(
          imagePath: ImageRes.imagePathLike,
          shadowColor: Color(0xFFFFD1D1).withOpacity(0.3736),
          label: 'Feel',
        ),
        _buildButtonWithLabel(
          imagePath: ImageRes.imagePathClock,
          shadowColor: Color(0xFFF6D3FF).withOpacity(0.369),
          label: 'Get up',
        ),
        _buildButtonWithLabel(
          imagePath: ImageRes.imagePathGame,
          shadowColor: Color(0xFFFCA6C5).withOpacity(0.2741),
          label: 'Game',
        ),
        _buildButtonWithLabel(
          imagePath: ImageRes.imagePathFeel,
          shadowColor: Color(0xFFFFEA31).withOpacity(0.3495),
          label: 'Gossip',
        ),
      ],
    );
  }

  Widget _buildButtonWithLabel({
    required String imagePath,
    required Color shadowColor,
    required String label,
  }) {
    return Expanded(
      child: Column(
        children: [
          HomeIconButton(
            imagePath: imagePath,
            shadowColor: shadowColor,
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

