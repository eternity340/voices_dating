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
            middleText: '     Verify',
            child: Container(),
          ),
          PathBox(
            top: 124.h,
            text: 'Verify Photo',
            onPressed: () {
              Get.toNamed('/me/verify/verify_photo', arguments: {'token': tokenEntity, 'userData': userData});
            },
          ),
          PathBox(
            top: 219.h,
            text: 'Verify ID',
            onPressed: () {
              Get.toNamed('/me/verify/verify_ID', arguments: {'token': tokenEntity, 'userData': userData});

            },
          ),

        ],
      ),
    );
  }
}
