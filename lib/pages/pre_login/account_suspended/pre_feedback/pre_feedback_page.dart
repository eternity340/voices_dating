import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voices_dating/components/background.dart';
import 'package:voices_dating/constants/constant_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voices_dating/pages/pre_login/account_suspended/pre_feedback/pre_feedback_controller.dart';
import '../../../../components/gradient_btn.dart';
import '../../../../components/no_underline_input_field.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../image_res/image_res.dart';
import 'components/topic_subject_bottom_sheet.dart';

class PreFeedbackPage extends StatelessWidget {
  final PreFeedbackController controller = Get.put(PreFeedbackController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        showMiddleText: true,
        middleText: ConstantData.feedbackTitleText,
        showBackgroundImage: true,
        child: Padding(
          padding: EdgeInsets.only(top: 60.h),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NoUnderlineInputField(
                    label: 'Your username',
                    controller: controller.usernameController,
                  ),
                  SizedBox(height: 10.h),
                  NoUnderlineInputField(
                    label: 'Your email',
                    isEmail: true,
                    controller: controller.emailController,
                  ),
                  SizedBox(height: 10.h),
                  NoUnderlineInputField(
                    label: 'Your phone number',
                    controller: controller.phoneController,
                  ),
                  SizedBox(height: 10.h),
                  TopicSubjectBottomSheet(
                    label: 'Topic / Subject',
                    topicOptions: [
                      'Premium membership / Payment /Billing issues',
                      'Login / Password',
                      'Registration / Account',
                      'Photos / Profile',
                      'Spark / Discover',
                      'Messages / Winks',
                      'Technical issues',
                      'Suggestions',
                      'Other'
                    ],
                    placeholder: 'Choose a topic',
                    onTopicSelected: (topic) {
                      controller.selectedTopic.value = topic;
                    },
                  ),
                  SizedBox(height: 10.h),
                  NoUnderlineInputField(
                    label: 'Describe details',
                    controller: controller.contentController,
                  ),
                  SizedBox(height: 10.h),
                  Material(
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
                  SizedBox(height: 30.h),
                  Center(
                    child: GradientButton(
                      text: ConstantData.submitButtonText,
                      onPressed: () {
                        controller.submitFeedback();
                      },
                      height: 49.h,
                      width: 248.w,
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

