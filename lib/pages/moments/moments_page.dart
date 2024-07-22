import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../components/all_navigation_bar.dart';
import '../../../entity/token_entity.dart';
import '../../components/background.dart';
import '../../entity/user_data_entity.dart';

class MomentsPage extends StatelessWidget {
  final tokenEntity = Get.arguments['token'] as TokenEntity;
  final userData = Get.arguments['userData'] as UserDataEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackButton: false,
            child: Container(),
          ),
          AllNavigationBar(tokenEntity: tokenEntity, userData: userData),
          Positioned(
            left: 16.w,
            top: 67.h,
            child: Text(
              'Moments',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
                color: Color(0xFF000000),
              ),
            ),
          ),
          Positioned(
            left: 315.w,
            top: 59.5.h,
            child: GestureDetector(
              onTap: () {
                // 添加点击事件处理
              },
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/button_round_search.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20.w,
            top: 139.h,
            child: Container(
              width: 335.w,
              height: 318.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0A000000).withOpacity(0.0642),
                    blurRadius: 14,
                    offset: Offset(0, 7),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 16.w,
                    top: 16.h,
                    child: Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey, // 这里你可以添加一个具体的颜色或图片
                      ),
                    ),
                  ),
                  Positioned(
                    left: 56.w, // 32 + 8 = 40 (椭圆的宽度加上间隔)
                    top: 20.h,
                    child: Text(
                      'David Li',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 14.sp,
                        height: 24 / 14, // 行高除以字号
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 231.w,
                    top: 12.h,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // 第一个按钮的点击事件处理
                          },
                          child: Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/button_round_message.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            // 第二个按钮的点击事件处理
                          },
                          child: Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/button_round_like.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
