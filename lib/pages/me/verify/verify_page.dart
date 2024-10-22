import 'package:voices_dating/constants/Constant_styles.dart';
import 'package:voices_dating/constants/constant_data.dart';
import 'package:voices_dating/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voices_dating/routes/components/right_to_left_transition.dart';
import '../../../components/background.dart';
import '../../../entity/token_entity.dart';
import '../../../entity/user_data_entity.dart';
import '../components/path_box.dart';
import '../me_page.dart';

class VerifyPage extends StatelessWidget {
  final tokenEntity = Get.arguments['tokenEntity'] as TokenEntity;
  final userData = Get.arguments['userDataEntity'] as UserDataEntity;

  void _navigateToMePage() {
    Get.to(() => MePage(),
      arguments: {
        'tokenEntity': tokenEntity,
        'userDataEntity': userData,
        'isMeActive': true,
      },
      transition: Transition.cupertinoDialog,
      duration: Duration(milliseconds: 500),
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
            /*PathBox(
              top: 124.h,
              text: ConstantData.verifyPhotoText,
              onPressed: () {
                Get.toNamed(AppRoutes.meVerifyPhoto,
                    arguments: {
                      'tokenEntity': tokenEntity,
                      'userDataEntity': userData
                    });
              },
            ),*/
            PathBox(
              top: 124.h,
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
