import 'package:first_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../components/background.dart';
import '../../../../../constants/Constant_styles.dart';
import '../../../../../constants/constant_data.dart';
import '../../../../../image_res/image_res.dart';
import 'components/audio_item.dart';
import 'record/record_page.dart';
import 'upload_voice_controller.dart';

class UploadVoicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadVoiceController>(
      init: UploadVoiceController(
          Get.arguments['tokenEntity'],
          Get.arguments['userDataEntity'],
          Get.arguments['recordFilePath']
      ),
      builder: (controller) => PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          navigateToMyProfile(controller);
        },
        child: Scaffold(
          body: Background(
            showMiddleText: true,
            showBackgroundImage: false,
            middleText: ConstantData.introductionText,
            child: Stack(
              children: [
                buildSaveButton(context, controller),
                buildAudioList(controller),
                buildRecordButton(controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBackground() {
    return Background(
      showMiddleText: true,
      showBackgroundImage: false,
      middleText: ConstantData.introductionText,
      child: Container(),
    );
  }

  Widget buildSaveButton(BuildContext context, UploadVoiceController controller) {
    return Positioned(
      top: 0.h,
      right: 0.w,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFD6FAAE), Color(0xFF20E2D7)],
          ),
          borderRadius: BorderRadius.circular(24.5.r),
        ),
        width: 88.w,
        height: 36.h,
        child: TextButton(
          onPressed: () => handleSave(context, controller),
          child: Text(
            ConstantData.saveText,
            style: ConstantStyles.actionButtonTextStyle,
          ),
        ),
      ),
    );
  }

  Widget buildAudioList(UploadVoiceController controller) {
    return Obx(() => Column(
      children: List.generate(controller.audioList.length, (index) {
        return Padding(
          padding: EdgeInsets.only(left: 10.w, top: (index == 0 ? 120 : 20).h),
          child: AudioItem(
            isSelected: controller.selectedIndex.value == index,
            onTap: () => controller.toggleSelection(index),
            onDelete: () => controller.deleteAudio(index),
            audioPath: controller.audioList[index],
          ),
        );
      }),
    ));
  }

  Widget buildRecordButton(UploadVoiceController controller) {
    return Positioned(
      left: 10.w,
      top: 540.h,
      child: GestureDetector(
        onTap: () => _navigateToRecordPage(controller),
        child: Container(
          width: 335.w,
          height: 69.h,
          decoration: BoxDecoration(
            color: Color(0xFFAAFCCF),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 26.w,
                top: 19.h,
                child: Image.asset(
                  ImageRes.microphoneImagePath,
                  width: 31.2.w,
                  height: 31.2.h,
                ),
              ),
              Positioned(
                left: 73.2.w,
                top: 23.1.h,
                child: Text(
                  ConstantData.recordButtonText,
                  style: ConstantStyles.recordButtonTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToMyProfile(UploadVoiceController controller) {
    Get.offAllNamed(AppRoutes.meMyProfile, arguments: {
      'token': controller.tokenEntity,
      'userData': controller.userData,
    });
  }

  void handleSave(BuildContext context, UploadVoiceController controller) async {
    if (controller.selectedIndex.value != -1) {
      bool success = await controller.saveSelectedVoice();
      if (success) {
        navigateToMyProfile(controller);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save voice')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a voice to save')),
      );
    }
  }

  void _navigateToRecordPage(UploadVoiceController controller) {
    Get.to(() => RecordPage(), arguments: {
      'token': controller.tokenEntity,
      'userData': controller.userData,
    });
  }
}
