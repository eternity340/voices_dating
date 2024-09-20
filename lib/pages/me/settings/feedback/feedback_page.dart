import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voices_dating/components/gradient_btn.dart';
import 'package:voices_dating/components/background.dart';
import 'package:voices_dating/pages/me/settings/feedback/feedback_controller.dart';
import '../../../../constants/constant_data.dart';
import '../../../../constants/constant_styles.dart';
import '../../../../image_res/image_res.dart';

class FeedbackPage extends StatelessWidget {
  final FeedbackController controller = Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showMiddleText: true,
            middleText: ConstantData.feedbackTitleText,
            showBackgroundImage: false,
            showBackButton: true,
            child: Container(),
          ),
          Positioned(
            left: 10.w,
            top: 139.h,
            child: Container(
              width: 335.w,
              height: 201.h,
              decoration: ConstantStyles.feedbackContainerDecoration,
              child: Stack(
                children: [
                  Positioned(
                    left: 16.w,
                    top: 16.h,
                    child: Text(
                      ConstantData.yourIdText,
                      style: ConstantStyles.yourIdTextStyle,
                    ),
                  ),
                  Positioned(
                    top: 42.h,
                    child: Container(
                      width: 297.w,
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: TextField(
                        controller: controller.feedbackController,
                        decoration: InputDecoration(
                          hintText: ConstantData.feedbackHintText,
                          hintStyle: ConstantStyles.feedbackHintStyle,
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        maxLines: 5,
                        minLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 10.w,
            top: 356.h,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10.r),
                onTap: () {
                  controller.pickImage();
                },
                child: Obx(() => Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: ConstantStyles.imageContainerDecoration.copyWith(
                    image: controller.selectedImagePath.value.isNotEmpty
                        ? DecorationImage(
                      image: FileImage(
                        File(controller.selectedImagePath.value),
                      ),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: controller.selectedImagePath.value.isEmpty
                      ? Center(
                    child: Image.asset(
                      ImageRes.imagePathIconAddPhoto,
                      width: 24.w,
                      height: 24.h,
                    ),
                  )
                      : null,
                )),
              ),
            ),
          ),
          Positioned(
            top: 650.h,
            left: 0,
            right: 0,
            child: Center(
              child: GradientButton(
                text: ConstantData.submitButtonText,
                onPressed: () {
                  controller.submitFeedback();
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