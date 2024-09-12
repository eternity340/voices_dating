import 'package:camera/camera.dart';
import 'package:first_app/components/background.dart';
import 'package:first_app/pages/me/verify/verify_video/verify_video_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../components/gradient_btn.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../constants/constant_data.dart';
import 'components/Circle_painter.dart';

class VerifyVideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyVideoController>(
      init: VerifyVideoController(
        tokenEntity: Get.arguments['tokenEntity'],
        userData: Get.arguments['userDataEntity'],
      ),
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              Background(
                showBackgroundImage: false,
                showMiddleText: true,
                showBackButton: true,
                middleText: ConstantData.verifyVideoText,
                child: Container(),
              ),
              Positioned(
                top: 150.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 256.w,
                        height: 256.w,
                        child: CustomPaint(
                          painter: CirclePainter(
                            rectColors: controller.rectColors,
                            rectScales: controller.rectScales,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 246.w,
                        height: 246.w,
                        child: ClipOval(
                          child: controller.isCameraInitialized.value &&
                              controller.cameraController.value != null &&
                              controller.cameraController.value!.value.isInitialized
                              ? CameraPreview(controller.cameraController.value!)
                              : Container(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 450.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Obx(() => Text(
                    controller.displayText.value,
                    style: ConstantStyles.displayTextStyle,
                    textAlign: TextAlign.center,
                  )),
                ),
              ),
              Positioned(
                top: 530.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    ConstantData.followPromptsText,
                    style: ConstantStyles.followPromptsTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                bottom: 150.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Obx(() => GradientButton(
                    text: ConstantData.startText,
                    onPressed: controller.isRecording.value ? null : () {
                      controller.startAnimation();
                    },
                    height: 49.h,
                    width: 248.w,
                    isDisabled: controller.isRecording.value,
                  )),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


