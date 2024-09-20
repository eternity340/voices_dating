/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../../../constants/constant_data.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../components/custom_message_dialog.dart';
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
              Get.toNamed('/me/settings/block_member',
                  arguments: {'token': tokenEntity, 'userData': userData});
            },
          ),
          PathBox(
            top: 219.h,
            text: 'Feedback',
            onPressed: () {
              Get.toNamed('/me/settings/feedback',
                  arguments: {'token': tokenEntity, 'userData': userData});
            },
          ),
          PathBox(
            top: 314.h,
            text: 'Purchase record',
            onPressed: () {
              Get.toNamed('/me/settings/purchase_record',
                  arguments: {'token': tokenEntity, 'userData': userData});
            },
          ),
          PathBox(
            top: 409.h,
            text: 'About me',
            onPressed: () {
              Get.toNamed('/me/settings/about_me',
                  arguments: {'token': tokenEntity, 'userData': userData});
            },
          ),
          PathBox(
            top: 504.h,
            text: 'Clean up memory',
            onPressed: () {
              Get.toNamed('/me/settings/',
                  arguments: {'token': tokenEntity, 'userData': userData});
            },
          ),
          Positioned(
            top: 650.h,
            left: 0,
            right: 0,
            child: Center(
              child: GradientButton(
                text: 'Sign Out',
                onPressed: () {
                  showCustomMessageDialog(context, signOut);
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


  void showCustomMessageDialog(BuildContext context, VoidCallback onYesPressed) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomMessageDialog(
          title: Text('Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          onYesPressed: onYesPressed,
        );
      },
    );
  }

  Future<void> signOut() async {
    final dio = Dio();
    try {
      final response = await dio.post(
        'https://api.masonvips.com/v1/signout',
        options: Options(
          headers: {
            'token': tokenEntity.accessToken,
          },
        ),
      );
      if (response.data['code'] == 200) {
        Get.snackbar('Success', 'Sign out successful',
            snackPosition: SnackPosition.BOTTOM);
        Get.offAllNamed('/welcome');
      } else {
        Get.snackbar('Error', 'Failed to sign out',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while signing out',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}*/
