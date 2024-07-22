import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../components/profile_photo_wall.dart';
import 'profile_detail_controller.dart';
import '../../../entity/list_user_entity.dart';
import '../components/profile_card.dart'; // Import the ProfileCard component

class ProfileDetailPage extends StatelessWidget {
  final ProfileDetailController controller;

  ProfileDetailPage({Key? key, required ListUserEntity userEntity})
      : controller = ProfileDetailController(userEntity: userEntity),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showSettingButton: false,
            showBackButton: false,
            child: Container(),
          ),
      Positioned.fill(
        top: 0,
        bottom: 72.h,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/back.png',
                            width: 24.w,
                            height: 24.h,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Back',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 14.sp,
                              color: Colors.black,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // 处理设置按钮点击事件
                      },
                      child: Image.asset(
                        'assets/images/button_round_setting.png',
                        width: 40.w,
                        height: 40.h,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: ProfilePhotoWall(controller: controller),
                  ),
                  Positioned(
                    top: 280.h,
                    left: MediaQuery.of(context).size.width * 0.5 - 141.5.w,
                    child: Container(
                      width: 283.w,
                      height: 166.h,
                      child: ProfileCard(userEntity: controller.userEntity),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 156.h),
              Container(
                width: 355.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Headline',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: 'Open Sans',
                        color: Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      controller.userEntity.headline ?? '',
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
                              (controller.userEntity.height != null ? '${controller.userEntity.height}cm' : ''),
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
                              'assets/images/icon_occupation.png',
                              width: 24.w,
                              height: 24.h,
                            ),
                            SizedBox(width: 16.w),
                            /*Text(
                              controller.userEntity.occupation ?? '',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: 'Open Sans',
                                height: 1.5,
                                letterSpacing: -0.01,
                                color: Color(0xFF000000),
                              ),
                            ),*/
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
                              controller.userEntity.language ?? '',
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
                              'assets/images/icon_emotional_state.png',
                              width: 24.w,
                              height: 24.h,
                            ),
                            SizedBox(width: 16.w),
                            /*Text(
                              controller.userEntity.emotionalState ?? '',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: 'Open Sans',
                                height: 1.5,
                                letterSpacing: -0.01,
                                color: Color(0xFF000000),
                              ),
                            ),*/
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),

      Positioned(
            bottom: 0.h,
            left: 0.w,
            right: 0.w,
            child: Container(
              height: 72.h,
              width: 375.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                boxShadow:  [
                  BoxShadow(
                    color: Color(0x5CD4D7E0),
                    offset: Offset(0, -20.h),
                    blurRadius: 30.w,
                  ),
                ],
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 89.76, sigmaY: 89.76),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.white.withOpacity(0.7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 52.w),
                        Image.asset(
                          'assets/images/icon_call.png',
                          width: 24.w,
                          height: 43.5.h,
                        ),
                        SizedBox(width: 52.w),
                        Image.asset(
                          'assets/images/icon_message.png',
                          width: 24.w,
                          height: 43.5.h,
                        ),
                        Spacer(),
                        GradientButton(
                          text: 'wink',
                          onPressed: () {},
                          width: 177.w,
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            letterSpacing: 2.0,
                          ),
                        ),
                        SizedBox(width: 16.w),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
