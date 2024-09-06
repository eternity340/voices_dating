import 'dart:io';
import 'package:first_app/components/background.dart';
import 'package:first_app/entity/list_user_entity.dart';
import 'package:first_app/entity/user_data_entity.dart';
import 'package:first_app/pages/home/user_profile/user_report/user_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../constants/constant_data.dart';
import '../../../../entity/token_entity.dart';
import '../../../../image_res/image_res.dart';
import '../../profile_detail/report/components/report_option.dart';


class UserReportPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final UserReportController controller = Get.put(
      UserReportController(
        Get.arguments['tokenEntity'] as TokenEntity,
        Get.arguments['userDataEntity'] as UserDataEntity,
      ),
    );

    return Scaffold(
      body: GetBuilder<UserReportController>(
        builder: (_) {
          return Stack(
            children: [
              Background(
                showMiddleText: true,
                showBackgroundImage: false,
                middleText: ConstantData.reportTitle,
                child: Container(),
              ),
              Positioned(
                top: 58.h,
                right: 0.w,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  transform: Matrix4.translationValues(-8.w, 0, 0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF20E2D7), Color(0xFFD6FAAE)],
                    ),
                    borderRadius: BorderRadius.circular(24.5.r),
                  ),
                  width: 88.w,
                  height: 36.h,
                  child: TextButton(
                    onPressed: () async {
                      await controller.report();
                    },
                    child: Text(
                      ConstantData.submitButtonText,
                      style: ConstantStyles.actionButtonTextStyle,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10.w,
                top: 110.h,
                child: ReportOption(
                  optionText: ConstantData.pornographicOption,
                  isSelected: controller.selectedOption == ConstantData.pornographicOption,
                  onSelect: () => controller.selectOption(ConstantData.pornographicOption),
                ),
              ),
              Positioned(
                left: 10.w,
                top: 200.h,
                child: ReportOption(
                  optionText: ConstantData.violentOption,
                  isSelected: controller.selectedOption == ConstantData.violentOption,
                  onSelect: () => controller.selectOption(ConstantData.violentOption),
                ),
              ),
              Positioned(
                left: 10.w,
                top: 290.h,
                child: ReportOption(
                  optionText: ConstantData.maliciousAttackOption,
                  isSelected: controller.selectedOption == ConstantData.maliciousAttackOption,
                  onSelect: () => controller.selectOption(ConstantData.maliciousAttackOption),
                ),
              ),
              Positioned(
                left: 10.w,
                top: 380.h,
                child: ReportOption(
                  optionText: ConstantData.disgustingOption,
                  isSelected: controller.selectedOption == ConstantData.disgustingOption,
                  onSelect: () => controller.selectOption(ConstantData.disgustingOption),
                ),
              ),
              Positioned(
                left: 10.w,
                top: 470.h,
                child: buildOtherOption(controller),
              ),
              Positioned(
                left: 10.w,
                top: 690.h,
                child: buildImagePicker(controller),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildOtherOption(UserReportController controller) {
    return GetBuilder<UserReportController>(
      builder: (_) => GestureDetector(
        onTap: () => controller.selectOption(ConstantData.otherOption),
        child: Container(
          width: 335.w,
          height: 201.h,
          decoration: buildContainerDecoration(controller),
          child: Stack(
            children: [
              buildOtherOptionTitle(controller),
              buildTextField(controller),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration buildContainerDecoration(UserReportController controller) {
    return BoxDecoration(
      color: controller.isOtherSelected ? Colors.white : Color(0xFFF8F8F9),
      borderRadius: BorderRadius.circular(10.r),
      border: controller.isOtherSelected
          ? Border.all(color: Color(0xFF32EA76), width: 2)
          : null,
    );
  }

  Widget buildOtherOptionTitle(UserReportController controller) {
    return Positioned(
      left: controller.isOtherSelected ? 14.w : 16.w,
      top: controller.isOtherSelected ? 14.h : 16.h,
      child: Text(
        ConstantData.otherOption,
        style: ConstantStyles.reportOptionStyle,
      ),
    );
  }

  Widget buildTextField(UserReportController controller) {
    return Positioned(
      left: controller.isOtherSelected ? 14.w : 16.w,
      top: controller.isOtherSelected ? 60.h : 62.h,
      right: controller.isOtherSelected ? 14.w : 16.w,
      bottom: controller.isOtherSelected ? 14.h : 16.h,
      child: TextField(
        controller: controller.textEditingController,
        decoration: buildTextFieldDecoration(),
        style: ConstantStyles.feedbackHintStyle,
        maxLines: 5,
        minLines: 1,
        enabled: controller.isOtherSelected,
        onTap: () => handleTextFieldTap(controller),
      ),
    );
  }

  InputDecoration buildTextFieldDecoration() {
    return InputDecoration(
      hintText: ConstantData.describeProblem,
      hintStyle: ConstantStyles.feedbackHintStyle,
      border: InputBorder.none,
      filled: true,
      fillColor: Colors.transparent,
    );
  }

  void handleTextFieldTap(UserReportController controller) {
    if (!controller.isOtherSelected) {
      controller.selectOption(ConstantData.otherOption);
    }
  }

  Widget buildImagePicker(UserReportController controller) {
    return GetBuilder<UserReportController>(
      builder: (_) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10.r),
            onTap: controller.isOtherSelected
                ? () {
              controller.pickImage();
            }
                : null,
            child: Opacity(
              opacity: controller.isOtherSelected ? 1.0 : 0.5,
              child: Container(
                width: 120.w,
                height: 120.h,
                decoration: ConstantStyles.imageContainerDecoration.copyWith(
                  image: controller.selectedImagePath.isNotEmpty
                      ? DecorationImage(
                    image: FileImage(
                      File(controller.selectedImagePath),
                    ),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: controller.selectedImagePath.isEmpty
                    ? Center(
                  child: Image.asset(
                    ImageRes.imagePathIconAddPhoto,
                    width: 24.w,
                    height: 24.h,
                  ),
                )
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
