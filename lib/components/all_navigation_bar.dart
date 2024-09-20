import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../entity/token_entity.dart';
import '../entity/user_data_entity.dart';
import '../image_res/image_res.dart';

class AllNavigationBar extends StatelessWidget {
  final TokenEntity tokenEntity;
  final UserDataEntity? userData;

  AllNavigationBar({required this.tokenEntity, this.userData});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 20.h,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 335.w,
              height: 72.h,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25.r),
                    child: Image.asset(
                      ImageRes.imagePathNavigationBar,
                      width: 335.w,
                      height: 72.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25.r),
                    child: Container(
                      width: 355.w,
                      height: 72.h,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  Positioned(
                    left: 40.w,
                    top: 26.h,
                    child: Row(
                      children: [
                        _buildNavItem(ImageRes.imagePathIconHomeActive, ImageRes.imagePathIconHomeInactive, '/home', userData),
                        SizedBox(width: 63.w),
                        _buildNavItem(ImageRes.imagePathIconBlogActive, ImageRes.imagePathIconBlogInactive, '/moments', userData),
                        SizedBox(width: 63.w),
                        // _buildNavItem(ImageRes.imagePathIconVoiceActive, ImageRes.imagePathIconVoiceInactive, '/voice', userData),
                        // SizedBox(width: 43.w),
                        _buildNavItem(ImageRes.imagePathIconMessageActive, ImageRes.imagePathIconMessageInactive, '/message', userData),
                        SizedBox(width: 63.w),
                        _buildNavItem(ImageRes.imagePathIconMeActive, ImageRes.imagePathIconMeInactive, '/me', userData),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(
      String activeIcon,
      String inactiveIcon,
      String route,
      UserDataEntity? userDataEntity) {
    bool isActive = Get.currentRoute == route;
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Get.offAllNamed(route, arguments: {
            'tokenEntity': tokenEntity,
            if (userData != null) 'userDataEntity': userDataEntity
          });
        }
      },
      child: Image.asset(
        isActive ? activeIcon : inactiveIcon,
        width: 23.w,
        height: 24.h,
      ),
    );
  }
}
