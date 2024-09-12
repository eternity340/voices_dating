import 'package:first_app/constants/Constant_styles.dart';
import 'package:first_app/constants/constant_data.dart';
import 'package:first_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../components/path_box.dart';

class VerifyPage extends StatelessWidget {
  final tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
  final userData = Get.arguments['userDataEntity'] as UserDataEntity;

  void _navigateToMePage() {
    Get.offAllNamed(
      AppRoutes.me,
      arguments: {
        'tokenEntity': tokenEntity,
        'userDataEntity': userData,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _navigateToMePage();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Background(
              showBackButton: true,
              showSettingButton: false,
              showBackgroundImage: false,
              showMiddleText: true,
              middleText: ConstantData.verifyButtonText,
              child: Container(),
              onBackPressed: _navigateToMePage,
            ),
            PathBox(
              top: 124.h,
              text: ConstantData.verifyPhotoText,
              onPressed: () {
                Get.toNamed(AppRoutes.meVerifyPhoto,
                    arguments: {
                      'tokenEntity': tokenEntity,
                      'userDataEntity': userData
                    });
              },
            ),
            PathBox(
              top: 219.h,
              text: ConstantData.verifyVideoText,
              onPressed: () {
                Get.toNamed(AppRoutes.meVerifyID,
                    arguments: {
                      'tokenEntity': tokenEntity,
                      'userDataEntity': userData
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
