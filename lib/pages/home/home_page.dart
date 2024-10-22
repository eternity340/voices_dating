import 'dart:convert';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/all_navigation_bar.dart';
import '../../components/background.dart';
import '../../components/empty_state_widget.dart';
import '../../constants/Constant_styles.dart';
import '../../constants/constant_data.dart';
import '../../entity/token_entity.dart';
import '../../image_res/image_res.dart';
import '../../service/app_service.dart';
import '../../utils/common_utils.dart';
import '../../utils/shared_preference_util.dart';
import 'components/home_icon_button.dart';
import 'components/user_card.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _refreshUserData();
    _initializeToken();
  }

  Future<void> _refreshUserData() async {
    await AppService.instance.syncUserData();
  }


  void _initializeToken() {
    final tokenJson = SharedPreferenceUtil.instance.getValue(
        key: SharedPresKeys.userToken);
    if (tokenJson != null) {
      final tokenEntity = TokenEntity.fromJson(json.decode(tokenJson));
      Get.put(HomeController(tokenEntity));
    } else {
      LogUtil.e(ConstantData.noTokenInLocal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        builder: (controller) {
          return Scaffold(
            body: Stack(
              children: [
                Background(
                  showBackButton: false,
                  child: Container(),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.all(16.0.sp),
                    child: Column(
                      children: [
                        SizedBox(height: 50.h),
                        _buildOptionsRow(controller),
                        _buildButtonRow(controller),
                        SizedBox(height: 0.h),
                        Expanded(
                          child: _buildAnimatedPageView(controller),
                        ),
                      ],
                    ),
                  ),
                ),
                if (controller.userData != null)
                  AllNavigationBar(tokenEntity: controller.tokenEntity,
                      userData: controller.userData!),
              ],
            ),
          );
        }
    );
  }

  Widget _buildOptionsRow(HomeController controller) {
    return Container(
      width: double.infinity,
      height: 35.h,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _buildOption(controller, ConstantData.honeyOption)),
          Expanded(child: _buildOption(controller, ConstantData.nearbyOption)),
        ],
      ),
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
                top: 0.h,
                right: 47.w,
                child: Image.asset(
                  ImageRes.imagePathDecorate,
                  width: 17.w,
                  height: 17.h,
                ),
              ),
            Text(
              option,
              style: ConstantStyles.homeOptionTextStyle(isSelected),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAnimatedPageView(HomeController controller) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
          top: 0.h,
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            children: [
              Container(
                height: 15.h,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 14.r,
                      offset: Offset(0, 7.h),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: (index) {
                    controller.onPageChanged(index);
                  },
                  children: [
                    honeyOption(controller),
                    nearbyOption(controller)
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget honeyOption(HomeController controller) {
    return Obx(() {
      if (controller.isInitialHoneyLoading.value) {
        return Center(child: CommonUtils.loadingIndicator());
      }
      return EasyRefresh(
        onRefresh: () async {
          controller.honeyCurrentPage = 1;
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
              child: UserCard(
                userEntity: controller.users[index],
                tokenEntity: controller.tokenEntity,
              ),
            );
          },
        ),
      );
    });
  }

  Widget nearbyOption(HomeController controller) {
    return Obx(() {
      if (controller.isInitialNearbyLoading.value) {
        return Center(child: CommonUtils.loadingIndicator());
      }
      if (controller.nearUsers.isEmpty) {
        return EmptyStateWidget(
          imagePath: ImageRes.emptyNearOptionSvg,
          message: 'No nearby users found',
          imageWidth: 200.w,
          imageHeight: 200.h,
          topPadding: 0.h,
        );
      }
      return EasyRefresh(
        onRefresh: () async {
          controller.nearbyCurrentPage = 1;
          controller.hasMoreData.value = true;
          controller.nearUsers.clear();
          await controller.fetchNearUsers();
        },
        onLoad: () async {
          await controller.fetchNearUsers();
        },
        child: ListView.builder(
          itemCount: controller.nearUsers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: UserCard(
                userEntity: controller.nearUsers[index],
                tokenEntity: controller.tokenEntity,
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildButtonRow(HomeController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HomeIconButton(
            imagePath: ImageRes.imagePathLike,
            shadowColor: Color(0xFFFFD1D1).withOpacity(0.3736),
            label: ConstantData.feelLabel,
            onTap: controller.navigateToFeelPage,
          ),
          HomeIconButton(
            imagePath: ImageRes.imagePathClock,
            shadowColor: Color(0xFFF6D3FF).withOpacity(0.369),
            label: ConstantData.viewLabel,
            onTap: controller.navigateToGetUpPage,
          ),
          HomeIconButton(
            imagePath: ImageRes.imagePathGame,
            shadowColor: Color(0xFFFCA6C5).withOpacity(0.2741),
            label: ConstantData.verifiedMemberLabel,
            onTap: controller.navigateToGamePage,
          ),
          HomeIconButton(
            imagePath: ImageRes.imagePathFeel,
            shadowColor: Color(0xFFFFEA31).withOpacity(0.3495),
            label: ConstantData.filtersLabel,
            onTap: controller.navigateToFiltersPage,
          ),
        ],
      ),
    );
  }
}
