import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../components/detail_bottom_bar.dart';
import '../../../constants/Constant_styles.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/list_user_entity.dart';
import '../../../entity/token_entity.dart';
import '../../../image_res/image_res.dart';
import '../components/profile_photo_wall.dart';
import '../components/profile_card.dart';

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
                            child: ProfileCard(
                              userEntity: userEntity,
                              tokenEntity: tokenEntity,
                            ),
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
                          ConstantData.headline,
                          style: ConstantStyles.headlineStyle,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          userEntity.headline ?? '',
                          style: ConstantStyles.bodyTextStyle,
                        ),
                        SizedBox(height: 50.h),
                        Text(
                          ConstantData.moments,
                          style: ConstantStyles.headlineStyle,
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          height: 105.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: ImageRes.momentImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 16.w),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.asset(
                                    ImageRes.momentImages[index],
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
                          ConstantData.aboutMe,
                          style: ConstantStyles.headlineStyle,
                        ),
                        SizedBox(height: 16.h),
                        Wrap(
                          spacing: 16.w,
                          runSpacing: 16.h,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  ImageRes.iconHeight,
                                  width: 24.w,
                                  height: 24.h,
                                ),
                                SizedBox(width: 16.w),
                                Text(
                                  (userEntity.height != null
                                      ? '${userEntity.height}cm'
                                      : ''),
                                  style: ConstantStyles.bodyTextStyle,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  ImageRes.iconLanguage,
                                  width: 24.w,
                                  height: 24.h,
                                ),
                                SizedBox(width: 16.w),
                                Text(
                                  userEntity.language ?? '',
                                  style: ConstantStyles.bodyTextStyle,
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
              gradientButtonText: ConstantData.chatButton,
              onGradientButtonPressed: () {
                // Handle GradientButton click event
              },
            ),
          ),
        ],
      ),
    );
  }
}
