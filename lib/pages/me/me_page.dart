import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:first_app/entity/token_entity.dart';
import 'package:first_app/entity/user_data_entity.dart';
import '../../components/all_navigation_bar.dart';
import '../../components/background.dart';
import '../../constants/Constant_styles.dart';
import '../../constants/constant_data.dart';
import '../../image_res/image_res.dart';
import 'components/outer_oval_painter.dart';
import 'me_controller.dart';

class MePage extends StatelessWidget {
  final MeController controller = Get.put(MeController());
  final tokenEntity = Get.arguments['token'] as TokenEntity;
  final userData = Get.arguments['userData'] as UserDataEntity;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        // 最小化应用
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
              child: _buildTopIcons(),
            ),
            Positioned(
              top: 130.h,
              left: 0,
              right: 0,
              child: _buildProfileSection(userData),
            ),
            Positioned(
              top: 330.h,
              left: MediaQuery.of(context).size.width / 2 - 167.5.w,
              child: _buildMiddleImageSection(context),
            ),
            Positioned(
              top: 500.h,
              left: MediaQuery.of(context).size.width / 2 - 167.5.w,
              child: _buildOptionsSection(context, tokenEntity, userData),
            ),
            AllNavigationBar(tokenEntity: tokenEntity, userData: userData),
          ],
        ),
      ),
    );
  }


  Widget _buildTopIcons() {
    return Row(
      children: [
        _buildIconButton(ImageRes.imagePathIconNotification, () {
          Get.toNamed('/me/notification', arguments: {'token': tokenEntity, 'userData': userData});
        }),
        SizedBox(width: 24.w),
        _buildIconButton(ImageRes.imagePathIconSetting, () {
          Get.toNamed('/me/settings', arguments: {'token': tokenEntity, 'userData': userData});
        }),
      ],
    );
  }

  Widget _buildIconButton(String assetPath, VoidCallback onPressed) {
    return Container(
      width: 40.w,
      height: 40.h,
      child: IconButton(
        icon: Image.asset(assetPath, width: 40.w, height: 40.h),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildProfileSection(UserDataEntity userData) {
    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(size: Size(95.w, 95.h), painter: OuterOvalPainter()),
              ClipOval(
                child: Image.network(
                  userData.avatar ?? ImageRes.placeholderAvatar,
                  width: 95.w,
                  height: 95.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      ImageRes.placeholderAvatar,
                      width: 95.w,
                      height: 95.h,
                      fit: BoxFit.cover,
                    );
                  },
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
                      Get.toNamed('/me/photo', arguments: {'token': tokenEntity, 'userData': userData});
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

  Widget _buildMiddleImageSection(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 335.w,
          height: 116.h,
          decoration: BoxDecoration(
            color: Color.fromRGBO(216, 216, 216, 0.01),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.black, width: 2.w),
          ),
        ),
        Image.asset(
          ImageRes.imagePathBuyCactus,
          width: 335.w,
          height: 117.h,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  Widget _buildOptionsSection(BuildContext context, TokenEntity tokenEntity, UserDataEntity userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOptionRow(
          iconPath: ImageRes.imagePathIconPerson,
          text: ConstantData.myProfileText,
          onTap: () {
            Get.toNamed('/me/my_profile', arguments: {'token': tokenEntity, 'userData': userData});
          },
        ),
        _buildSeparator(),
        _buildOptionRow(
          iconPath: ImageRes.imagePathIconVerify,
          text: 'Verify',
          onTap: () {
            Get.toNamed('/me/verify', arguments: {'token': tokenEntity, 'userData': userData});
          },
        ),
        _buildSeparator(),
        _buildOptionRow(iconPath: ImageRes.imagePathIconHost, text: ConstantData.hostText, onTap: () {}),
        _buildSeparator(),
      ],
    );
  }

  Widget _buildOptionRow({required String iconPath, required String text, required VoidCallback onTap}) {
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
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Container(
          width: 303.w,
          height: 1.h,
          color: Color(0xFFEBEBEB),
        ),
        SizedBox(height: 30.h),
      ],
    );
  }
}
