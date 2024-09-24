import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voices_dating/components/background.dart';
import 'package:voices_dating/components/gradient_btn.dart';
import 'package:voices_dating/constants/constant_data.dart';
import 'package:voices_dating/constants/Constant_styles.dart';
import 'package:voices_dating/pages/home/filters/filters_controller.dart';

import 'filters_widget/age_filter.dart';
import 'filters_widget/location_filter.dart';
import 'filters_widget/looking_for_filter.dart';


class FiltersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FiltersController controller = Get.put(FiltersController());
    return Background(
      showBackButton: true,
      showBackgroundImage: true,
      showMiddleText: true,
      middleText: ConstantData.filtersLabel,
      child: Stack(
        children: [
          Positioned(
            top: 0.h,
            right: 10.w,
            child: Obx(() => GradientButton(
              text: ConstantData.saveText,
              width: 88.w,
              height: 36.h,
              onPressed: controller.onSavePressed,
              isDisabled: !controller.isButtonEnabled.value,
              textStyle: ConstantStyles.saveButtonTextStyle,
            )),
          ),
          Positioned(
            top: 60.h,
            left: 20.w,
            right: 20.w,
            bottom: 20.h,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AgeFilter(controller: controller),
                  SizedBox(height: 20.h),
                  LookingForFilter(controller: controller),
                  SizedBox(height: 20.h),
                  LocationFilter(controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
