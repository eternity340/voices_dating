import 'package:voices_dating/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/background.dart';
import '../../../components/gradient_btn.dart';
import '../components/path_box.dart';
import 'settings_controller.dart';
import '../../../constants/constant_data.dart';
import '../../../constants/constant_styles.dart';

class SettingsPage extends StatelessWidget {
  final SettingsController controller = Get.put(SettingsController());

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
            middleText: ConstantData.settings,
            child: Container(),
          ),
          PathBox(
            top: ConstantStyles.pathBoxTopSpacing,
            text: ConstantData.blockMembersText,
            onPressed: () => _navigateTo(AppRoutes.meSettingsBlockMember),
          ),
          PathBox(
            top: ConstantStyles.pathBoxTopSpacing + 95.h,
            text: ConstantData.feedbackTitleText,
            onPressed: () => _navigateTo(AppRoutes.meSettingsFeedback),
          ),
          PathBox(
            top: ConstantStyles.pathBoxTopSpacing + 190.h,
            text: ConstantData.purchaseRecord,
            onPressed: () => _navigateTo(AppRoutes.meSettingsPurchaseRecord),
          ),
          PathBox(
            top: ConstantStyles.pathBoxTopSpacing + 285.h,
            text: ConstantData.aboutMe,
            onPressed: () => _navigateTo(AppRoutes.meSettingsAboutMe),
          ),
          PathBox(
            top: ConstantStyles.pathBoxTopSpacing + 380.h,
            text: ConstantData.cleanUpMemory,
            onPressed: () => _navigateTo(AppRoutes.meSettings),
          ),
          Positioned(
            top: ConstantStyles.signOutButtonTop,
            left: 0,
            right: 0,
            child: Center(
              child: GradientButton(
                text: ConstantData.signOut,
                onPressed: () {
                  controller.showCustomMessageDialog(context, controller.signOut);
                },
                height: ConstantStyles.signOutButtonHeight,
                width: ConstantStyles.signOutButtonWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(String route) {
    Get.toNamed(route,
        arguments: {
          'tokenEntity': controller.tokenEntity,
          'userDataEntity': controller.userData});
  }
}