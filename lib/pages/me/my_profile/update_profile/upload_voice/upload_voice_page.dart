import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../components/background.dart';
import '../../../../../constants/Constant_styles.dart';
import '../../../../../constants/constant_data.dart';
import '../../../../../image_res/image_res.dart';
import 'components/audio_item.dart';
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
          controller.navigateToMeMyProfilePage();
        },
        child: Scaffold(
          body: Background(
            showMiddleText: true,
            showBackgroundImage: false,
            middleText: ConstantData.introductionText,
            onBackPressed: controller.navigateToMeMyProfilePage,
            child: Stack(
              children: [
                buildSaveButton(context, controller),
                Positioned(
                  top: 60.h,
                  left: 10.w,
                  right: 10.w,
                  bottom: 100.h,
                  child: SingleChildScrollView(
                    child: buildAudioList(controller),
                  ),
                ),
                buildRecordButton(controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSaveButton(BuildContext context, UploadVoiceController controller) {
    return Positioned(
      top: 0.h,
      right: 0.w,
      child: Obx(() => AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(-8.w, 0, 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: controller.isButtonEnabled
                ? [Color(0xFFD6FAAE), Color(0xFF20E2D7)]
                : [Color(0xFFC3C3CB), Color(0xFFC3C3CB)],
          ),
          borderRadius: BorderRadius.circular(24.5.r),
        ),
        width: 88.w,
        height: 36.h,
        child: TextButton(
          onPressed: controller.isButtonEnabled
              ? () => controller.handleSave(context)
              : null,
          child: Text(
            ConstantData.saveText,
            style: ConstantStyles.actionButtonTextStyle,
          ),
        ),
      )),
    );
  }



  Widget buildAudioList(UploadVoiceController controller) {
    return Obx(() => Column(
      children: List.generate(controller.audioList.length, (index) {
        return Padding(
          padding: EdgeInsets.only(left: 0.w, top: (index == 0 ? 20 : 20).h),
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
        onTap: controller.navigateToRecordPage,
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
}
