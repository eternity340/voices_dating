import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/token_entity.dart';
import '../components/profile_photo_wall.dart';
import '../components/profile_card.dart';
import '../../../components/detail_bottom_bar.dart';

  class ProfileDetailPage extends StatelessWidget {
      @override
    Widget build(BuildContext context) {
      final arguments = Get.arguments;
      final ListUserEntity userEntity = arguments?['userEntity'] as ListUserEntity;
      final TokenEntity tokenEntity = arguments['tokenEntity'] as TokenEntity;

      return Scaffold(
        body: Stack(
          children: [
            Background(
              showSettingButton: false,
              showBackButton: true,
              child: Container(),
            ),
            Positioned.fill(
              top: 100.h,
              bottom: 72.h,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ProfilePhotoWall(userEntity: userEntity),
                        Positioned(
                          top: 280.h, // Adjust this value as needed
                          left: 0,
                          right: 0,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: 283.w,
                              height: 166.h,
                              child: ProfileCard(userEntity: userEntity, tokenEntity: tokenEntity),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 350.w,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Headline',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontFamily: 'Open Sans',
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            userEntity.headline ?? '',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'Open Sans',
                              height: 1.5,
                              letterSpacing: -0.01,
                              color: Color(0xFF000000),
                            ),
                          ),
                          SizedBox(height: 50.h),
                          Text(
                            'Moments',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontFamily: 'Open Sans',
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Container(
                            height: 105.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 16.w),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.asset(
                                      'assets/images/0${index + 1}.jpg',
                                      width: 105.w,
                                      height: 105.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 50.h),
                          Text(
                            'About Me',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontFamily: 'Open Sans',
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Wrap(
                            spacing: 16.w,
                            runSpacing: 16.h,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/icon_height.png',
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                  SizedBox(width: 16.w),
                                  Text(
                                    (userEntity.height != null
                                        ? '${userEntity.height}cm'
                                        : ''),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: 'Open Sans',
                                      height: 1.5,
                                      letterSpacing: -0.01,
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/icon_language.png',
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                  SizedBox(width: 16.w),
                                  Text(
                                    userEntity.language ?? '',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: 'Open Sans',
                                      height: 1.5,
                                      letterSpacing: -0.01,
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: DetailBottomBar(
                showMomentLikeButton: false,
                gradientButtonText: 'Chat',
                onGradientButtonPressed: () {
                  // 处理GradientButton点击事件
                },
              ),
            ),
          ],
        ),
      );
    }
  }
