import 'package:first_app/constants/Constant_styles.dart';
import 'package:first_app/constants/constant_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../components/path_box.dart';

class VerifyPage extends StatelessWidget {
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
            middleText: ConstantData.verifyMiddleText,
            child: Container(),
          ),
          PathBox(
            top: 124.h,
            text: ConstantData.verifyPhotoText,
            onPressed: () {
              Get.toNamed('/me/verify/verify_photo', arguments: {'token': tokenEntity, 'userData': userData});
            },
          ),
          PathBox(
            top: 219.h,
            text: ConstantData.verifyIdText,
            onPressed: () {
              Get.toNamed('/me/verify/verify_ID', arguments: {'token': tokenEntity, 'userData': userData});

            },
          ),

        ],
      ),
    );
  }
}
