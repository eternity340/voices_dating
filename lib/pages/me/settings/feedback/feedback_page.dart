import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:first_app/components/gradient_btn.dart';
import 'package:first_app/components/background.dart';
import 'package:first_app/pages/me/settings/feedback/feedback_controller.dart';

class FeedbackPage extends StatelessWidget {
  final FeedbackController controller = Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            showMiddleText: true,
            middleText: '  Feedback',
            showBackgroundImage: false,
            showBackButton: true,
            child: Container(),
          ),
          Positioned(
            left: 20.w,
            top: 139.h,
            child: Container(
              width: 335.w,
              height: 201.h,
              decoration: BoxDecoration(
                color: Color(0xFFF8F8F9),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 16.w,
                    top: 16.h,
                    child: Text(
                      'Your idea',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 22 / 16,
                        letterSpacing: -0.01.sp,
                        color: Colors.black,
                      ),
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
                          hintText: 'Please inform us of our shortcomings and we will improve them as soon as possible.',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            height: 24 / 14,
                            letterSpacing: -0.01.sp,
                            color: Color(0xFF8E8E93),
                          ),
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
            left: 20.w,
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
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F8F9),
                    borderRadius: BorderRadius.circular(10.r),
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
                      'assets/images/icon_add_photo.png',
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
                text: 'submit',
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
