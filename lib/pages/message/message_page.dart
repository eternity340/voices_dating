import 'package:first_app/pages/message/components/liked_me_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../../components/all_navigation_bar.dart';
import '../../components/background.dart';
import '../../image_res/image_res.dart';
import 'components/loading_overlay.dart';
import 'components/message_content.dart';
import 'components/viewed_me_content.dart';
import 'message_controller.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late MessageController controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final TokenEntity tokenEntity = Get.arguments['token'] as TokenEntity;
    final UserDataEntity? userData = Get.arguments['userData'] as UserDataEntity?;
    controller = Get.put(MessageController(tokenEntity, userData!));
    _loadData();
  }

  Future<void> _loadData() async {
    await controller.fetchChattedUsers();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await SystemNavigator.pop();
      },
      child: GetBuilder<MessageController>(
        init: controller,
        builder: (controller) {
          return Scaffold(
            body: Stack(
              children: [
                if (_isLoading) LoadingOverlay(),
                Background(
                  showBackButton: false,
                  showBackgroundImage: true,
                  child: Container(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.w, top: 67.h),
                  child: Row(
                    children: [
                      _buildOption(controller, 'Messages', 0),
                      SizedBox(width: 50.w),
                      _buildOption(controller, 'Viewed Me', 1),
                      SizedBox(width: 50.w),
                      _buildOption(controller, 'Liked Me', 2),
                    ],
                  ),
                ),
                Positioned(
                  top: 139.h,
                  left: (ScreenUtil().screenWidth - 335.w) / 2,
                  child: Container(
                    width: 335.w,
                    height: 680.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F9),
                      borderRadius: BorderRadius.circular(24.r),
                      backgroundBlendMode: BlendMode.srcOver,
                    ),
                    child: PageView(
                      controller: controller.pageController,
                      onPageChanged: (index) {
                        controller.changeSelectedIndex(index);
                      },
                      children: [
                        MessageContent(
                          chattedUsers: controller.chattedUsers,
                          onRefresh: controller.fetchChattedUsers,
                          controller: controller,
                        ),
                        ViewedMeContent(controller: controller),
                        LikedMeContent(controller: controller)
                      ],
                    ),
                  ),
                ),
                if (controller.userDataEntity != null)
                  AllNavigationBar(
                    tokenEntity: controller.tokenEntity,
                    userData: controller.userDataEntity,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOption(MessageController controller, String text, int index) {
    bool isSelected = controller.selectedIndex == index;
    return GestureDetector(
      onTap: () {
        controller.changeSelectedIndex(index);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (isSelected)
            Positioned(
              right: 0.w,
              top: 0.h,
              child: Image.asset(
                ImageRes.imagePathDecorate,
                width: 17.w,
                height: 17.h,
              ),
            ),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              fontSize: isSelected ? 18.sp : 16.sp,
              height: 1.5,
              letterSpacing: -0.01,
              color: isSelected ? Colors.black : Color(0xFF8E8E93),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

