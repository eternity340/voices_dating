import 'package:voices_dating/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voices_dating/entity/token_entity.dart';
import 'package:voices_dating/entity/user_data_entity.dart';
import '../../components/all_navigation_bar.dart';
import '../../components/background.dart';
import 'components/separator.dart';
import '../../constants/Constant_styles.dart';
import '../../constants/constant_data.dart';
import '../../image_res/image_res.dart';
import 'components/outer_oval_painter.dart';
import 'me_controller.dart';

class MePage extends StatelessWidget {
  final MeController controller = Get.put(MeController());
  final tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
  final userDataEntity = Get.arguments['userDataEntity'] as UserDataEntity;
  final bool isMeActive = Get.arguments['isMeActive'] as bool? ?? false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await SystemNavigator.pop();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Background(
              showBackButton: false,
              showSettingButton: false,
              child: Container(),
            ),
            Positioned(
              top: 60.h,
              right: 24.w,
              child: topIcons(),
            ),
            Positioned(
              top: 130.h,
              left: 0,
              right: 0,
              child: profileSection(userDataEntity),
            ),
            Positioned(
              top: 330.h,
              left: 10.w,
              child: middleImageSection(context),
            ),
            Positioned(
              top: 500.h,
              left: 20.w,
              child: optionsSection(context, tokenEntity, userDataEntity),
            ),
            AllNavigationBar(
              tokenEntity: tokenEntity,
              userData: userDataEntity,
              isMeActive: isMeActive,  // 传递 isMeActive
            ),
          ],
        ),
      ),
    );
  }

  Widget topIcons() {
    return Row(
      children: [
        /*buildIconButton(ImageRes.imagePathIconNotification, () {
          Get.toNamed(AppRoutes.meNotification,
              arguments: {
                'tokenEntity': tokenEntity,
                'userDataEntity': userDataEntity});
        }),*/
        SizedBox(width: 5.w),
        buildIconButton(ImageRes.imagePathIconSetting, () {
          Get.toNamed(AppRoutes.meSettings,
              arguments: {
                'tokenEntity': tokenEntity,
                'userDataEntity': userDataEntity});
        }),
      ],
    );
  }

  Widget buildIconButton(String assetPath, VoidCallback onPressed) {
    return Container(
      width: 50.w,
      height: 50.h,
      child: IconButton(
        icon: Image.asset(assetPath, width: 50.w, height: 50.h),
        onPressed: onPressed,
      ),
    );
  }

  Widget profileSection(UserDataEntity userData) {
    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(size: Size(100.w, 110.h), painter: OuterOvalPainter()),
              ClipOval(
                child: Container(
                  width: 98.w,
                  height: 107.h,
                  child: userData.avatar != null
                      ? Image.network(
                    userData.avatar!,
                    width: 95.w,
                    height: 105.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        ImageRes.placeholderAvatar,
                        width: 95.w,
                        height: 105.h,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                      : Image.asset(
                    ImageRes.placeholderAvatar,
                    width: 95.w,
                    height: 105.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 34.w,
                  height: 34.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD7FAAD),
                  ),
                  child: IconButton(
                    icon: Image.asset(ImageRes.imagePathIconAddPhoto, width: 24.w, height: 24.h),
                    onPressed: () {
                      Get.toNamed(AppRoutes.mePhoto,
                          arguments: {
                            'tokenEntity': tokenEntity,
                            'userDataEntity': userData
                          });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          userData.username,
          style: ConstantStyles.mePageUsernameTextStyle,
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (userData.location != null && userData.location!.country != null)
              Text(
                userData.location!.country!,
                style: ConstantStyles.mePageTextStyle,
              ),
            if (userData.location != null && userData.location!.country != null)
              Text(
                ' | ',
                style: ConstantStyles.mePageTextStyle,
              ),
            Text(
              '${userData.age}',
              style: ConstantStyles.mePageTextStyle,
            ),
          ],
        ),
      ],
    );
  }

  Widget middleImageSection(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 15.w,
          child: Container(
            width: 305.w,
            height: 116.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.black, width: 2.w),
            ),
          ),
        ),
        Stack(
          children: [
            Image.asset(
              ImageRes.buyCactusNoWords,
              width: 335.w,
              height: 117.h,
              fit: BoxFit.contain,
            ),
            Positioned(
              left: 164.w,
              top: 23.5.h,
              child: Text(
                ConstantData.voicesDatingTitle,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  height: 16 / 18,
                  letterSpacing: -0.01,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              left: 120.w,
              top: 66.5.h,
              child: Container(
                width: 196.w,
                height: 32.h,
                child: Text(
                  ConstantData.voicesDatingContent,
                  style: ConstantStyles.buyCactusContentStyle
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget optionsSection(
      BuildContext context,
      TokenEntity tokenEntity,
      UserDataEntity userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOptionRow(
          iconPath: ImageRes.imagePathIconPerson,
          text: ConstantData.myProfileText,
          onTap: () {
            Get.toNamed(
                AppRoutes.meMyProfile,
                arguments: {
                  'tokenEntity': tokenEntity,
                  'userDataEntity': userDataEntity
                });
          },
        ),
        separator(),
        _buildOptionRow(
          iconPath: ImageRes.imagePathIconVerify,
          text: ConstantData.verifyButtonText,
          onTap: () {
            Get.toNamed(AppRoutes.meVerify,
                arguments: {
                  'tokenEntity': tokenEntity,
                  'userDataEntity': userDataEntity
                });
          },
          showVerifiedIcon: userDataEntity.verified == '1',
        ),
        separator(),
        _buildOptionRow(
          iconPath: ImageRes.imagePathIconHost,
          text: ConstantData.hostText,
          onTap: () {
            Get.toNamed(AppRoutes.meHost,
                arguments: {
                  'tokenEntity': tokenEntity,
                  'userDataEntity': userDataEntity
                });
          },
        ),
        separator(),
      ],
    );
  }


  Widget _buildOptionRow({
    required String iconPath,
    required String text,
    required VoidCallback onTap,
    bool showVerifiedIcon = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(iconPath, width: 24.w, height: 24.h),
          SizedBox(width: 16.w),
          Text(
            text,
            style: ConstantStyles.mePageOptionTextStyle,
          ),
          if (showVerifiedIcon)
            SizedBox(width: 8.w),
          if (showVerifiedIcon)
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Color(0xFFAAFCCF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.black,
                size: 14.w,
              ),
            ),
        ],
      ),
    );
  }



}
