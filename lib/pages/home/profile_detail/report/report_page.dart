import 'dart:io';
import 'package:voices_dating/components/background.dart';
import 'package:voices_dating/entity/list_user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../components/gradient_btn.dart';
import '../../../../constants/Constant_styles.dart';
import '../../../../constants/constant_data.dart';
import '../../../../entity/token_entity.dart';
import '../../../../image_res/image_res.dart';
import '../../../../components/option_selector.dart';
import 'report_controller.dart';

class ReportPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final ReportController controller = Get.put(
      ReportController(
        Get.arguments['tokenEntity'] as TokenEntity,
        Get.arguments['userId'] as String,
      ),
    );

    return Scaffold(
      body: Background(
        showMiddleText: true,
        showBackgroundImage: false,
        middleText: ConstantData.reportTitle,
        child: GetBuilder<ReportController>(
          builder: (_) {
            return Stack(
              children: [
                Positioned(
                  top: 0.h,
                  right: 10.w,
                  child: GradientButton(
                    text: ConstantData.submitButtonText,
                    width: 88,
                    height: 36,
                    onPressed: () async {
                      await controller.report();
                    },
                    isDisabled: !controller.isSubmitEnabled,
                  ),
                ),
                Positioned(
                  left: 10.w,
                  top: 60.h,
                  child: OptionSelector(
                    optionText: ConstantData.pornographicOption,
                    isSelected: controller.selectedOption == ConstantData.pornographicOption,
                    onSelect: () => controller.selectOption(ConstantData.pornographicOption),
                  ),
                ),
                Positioned(
                  left: 10.w,
                  top: 150.h,
                  child: OptionSelector(
                    optionText: ConstantData.violentOption,
                    isSelected: controller.selectedOption == ConstantData.violentOption,
                    onSelect: () => controller.selectOption(ConstantData.violentOption),
                  ),
                ),
                Positioned(
                  left: 10.w,
                  top: 240.h,
                  child: OptionSelector(
                    optionText: ConstantData.maliciousAttackOption,
                    isSelected: controller.selectedOption == ConstantData.maliciousAttackOption,
                    onSelect: () => controller.selectOption(ConstantData.maliciousAttackOption),
                  ),
                ),
                Positioned(
                  left: 10.w,
                  top: 330.h,
                  child: OptionSelector(
                    optionText: ConstantData.disgustingOption,
                    isSelected: controller.selectedOption == ConstantData.disgustingOption,
                    onSelect: () => controller.selectOption(ConstantData.disgustingOption),
                  ),
                ),
                Positioned(
                  left: 10.w,
                  top: 420.h,
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
      ),
    );
  }

  Widget buildOtherOption(ReportController controller) {
    return GetBuilder<ReportController>(
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

  BoxDecoration buildContainerDecoration(ReportController controller) {
    return BoxDecoration(
      color: controller.isOtherSelected ? Colors.white : Color(0xFFF8F8F9),
      borderRadius: BorderRadius.circular(10.r),
      border: controller.isOtherSelected
          ? Border.all(color: Color(0xFF32EA76), width: 2)
          : null,
    );
  }

  Widget buildOtherOptionTitle(ReportController controller) {
    return Positioned(
      left: controller.isOtherSelected ? 14.w : 16.w,
      top: controller.isOtherSelected ? 14.h : 16.h,
      child: Text(
        ConstantData.otherOption,
        style: ConstantStyles.reportOptionStyle,
      ),
    );
  }

  Widget buildTextField(ReportController controller) {
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

  void handleTextFieldTap(ReportController controller) {
    if (!controller.isOtherSelected) {
      controller.selectOption(ConstantData.otherOption);
    }
  }

  Widget buildImagePicker(ReportController controller) {
    return GetBuilder<ReportController>(
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
