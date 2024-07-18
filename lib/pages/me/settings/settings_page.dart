import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../components/path_box.dart';

class SettingsPage extends StatelessWidget {
  final tokenEntity = Get.arguments['token'] as TokenEntity;
  final userData = Get.arguments['userData'] as UserDataEntity;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Background(
            showBackButton: true,
            showSettingButton: false,
            showBackgroundImage: false,
            showMiddleText: true,
            middleText: '   Settings',
            child: Container(),
          ),
          PathBox(
            top: 124.h,
            text: 'Block members',
            onPressed: () {
              Get.toNamed('/me/settings/', arguments: {'token': tokenEntity});
            },
          ),
          PathBox(
            top: 219.h,
            text: 'Feedback',
            onPressed: () {
              Get.toNamed('/me/settings/', arguments: {'token': tokenEntity});
            },
          ),
          PathBox(
            top: 314.h,
            text: 'Purchase record',
            onPressed: () {
              Get.toNamed('/me/settings/', arguments: {'token': tokenEntity});
            },
          ),
          PathBox(
            top: 409.h,
            text: 'About me',
            onPressed: () {
              Get.toNamed('/me/settings/', arguments: {'token': tokenEntity});
            },
          ),
          PathBox(
            top: 409.h,
            text: 'Clean up memory',
            onPressed: () {
              Get.toNamed('/me/settings/', arguments: {'token': tokenEntity});
            },
          ),
          Positioned(
            top: 600.h,
            left: 0,
            right: 0,
            child: Center(
              child: GradientButton(
                text: 'Sign Out',
                onPressed: () {
                },
                height: 49.h,
                width: 248.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
