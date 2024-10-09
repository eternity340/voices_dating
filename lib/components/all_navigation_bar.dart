/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../entity/token_entity.dart';
import '../entity/user_data_entity.dart';
import '../image_res/image_res.dart';

class AllNavigationBar extends StatelessWidget {
  final TokenEntity tokenEntity;
  final UserDataEntity? userData;
  final bool isMeActive;

  AllNavigationBar({
    required this.tokenEntity,
    this.userData,
    this.isMeActive = false
  });

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
                        _buildNavItem(ImageRes.imagePathIconMeActive, ImageRes.imagePathIconMeInactive, '/me', userData, isMeActive),
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
      UserDataEntity? userDataEntity,
      [bool forceActive = false]) {  // 添加可选参数
    bool isActive = Get.currentRoute == route || (route == '/me' && forceActive);
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
}*/

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../entity/token_entity.dart';
import '../entity/user_data_entity.dart';
import '../image_res/image_res.dart';

class AllNavigationBar extends StatelessWidget {
  final TokenEntity tokenEntity;
  final UserDataEntity? userData;
  final bool isMeActive;

  AllNavigationBar({
    required this.tokenEntity,
    this.userData,
    this.isMeActive = false
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0.h,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 355.w,
              height: 72.h,
              child: Stack(
                children: [
                  ClipRect(
                    child: OverflowBox(
                      maxWidth: double.infinity,
                      child: Image.asset(
                        ImageRes.imagePathNavigationBar,
                        width: 500.w, // 增加宽度以放大图片
                        height: 100.h, // 增加高度以放大图片
                        fit: BoxFit.cover, // 使用 BoxFit.cover 来覆盖并保持宽高比
                      ),
                    ),
                  ),
                  Container(
                    width: 355.w,
                    height: 72.h,
                    color: Colors.white.withOpacity(0.6),
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
                        _buildNavItem(ImageRes.imagePathIconMessageActive, ImageRes.imagePathIconMessageInactive, '/message', userData),
                        SizedBox(width: 63.w),
                        _buildNavItem(ImageRes.imagePathIconMeActive, ImageRes.imagePathIconMeInactive, '/me', userData, isMeActive),
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
      UserDataEntity? userDataEntity,
      [bool forceActive = false]) {
    bool isActive = Get.currentRoute == route || (route == '/me' && forceActive);
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
}*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voices_dating/routes/app_routes.dart';
import '../entity/token_entity.dart';
import '../entity/user_data_entity.dart';
import '../image_res/image_res.dart';

class AllNavigationBar extends StatelessWidget {
  final TokenEntity tokenEntity;
  final UserDataEntity? userData;
  final bool isMeActive;

  AllNavigationBar({
    required this.tokenEntity,
    this.userData,
    this.isMeActive = false
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        width: ScreenUtil().screenWidth,
        height: 72.h ,
        child: Stack(
          children: [
            ClipRect(
              child: OverflowBox(
                maxWidth: double.infinity,
                child: Image.asset(
                  ImageRes.imagePathNavigationBar,
                  width: ScreenUtil().screenWidth * 1.5,
                  height: 110.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              color: Colors.white.withOpacity(0.6),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Container(
                height: 72.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                        ImageRes.imagePathIconHomeActive,
                        ImageRes.imagePathIconHomeInactive,
                        AppRoutes.home,
                        userData
                    ),
                    _buildNavItem(
                        ImageRes.imagePathIconBlogActive,
                        ImageRes.imagePathIconBlogInactive,
                        AppRoutes.moments,
                        userData
                    ),
                    _buildNavItem(
                        ImageRes.imagePathIconMessageActive,
                        ImageRes.imagePathIconMessageInactive,
                        AppRoutes.message,
                        userData
                    ),
                    _buildNavItem(
                        ImageRes.imagePathIconMeActive,
                        ImageRes.imagePathIconMeInactive,
                        AppRoutes.me,
                        userData,
                        isMeActive
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      String activeIcon,
      String inactiveIcon,
      String route,
      UserDataEntity? userDataEntity,
      [bool forceActive = false]) {
    bool isActive = Get.currentRoute == route || (route == '/me' && forceActive);
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Get.offAllNamed(route, arguments: {
            'tokenEntity': tokenEntity,
            if (userData != null) 'userDataEntity': userDataEntity
          });
        }
      },
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 500),
        tween: Tween<double>(begin: 0, end: isActive ? 1 : 0),
        curve: Curves.elasticOut,
        builder: (context, double value, child) {
          return Container(
            padding: EdgeInsets.all(8.w * value),
            decoration: BoxDecoration(
              color: Color.lerp(Colors.transparent, Colors.white.withOpacity(0.3), value),
              borderRadius: BorderRadius.circular(20.r * value),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1 * value),
                  blurRadius: 10 * value,
                  spreadRadius: 2 * value,
                ),
              ],
            ),
            child: Transform.scale(
              scale: 1 + (0.2 * value),
              child: Image.asset(
                isActive ? activeIcon : inactiveIcon,
                width: 23.w,
                height: 24.h,
              ),
            ),
          );
        },
      ),
    );
  }
}


